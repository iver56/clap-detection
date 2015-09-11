<CsoundSynthesizer>
<CsOptions>
-odac   -iadc   ;;;realtime audio I/O
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs  = 1

pyinit

instr 1
	pyruni "import time"
	kLastRms init 0
	kLastAttack init 0
	iRmsDiffThreshold init .0002
	
	aIn in
	kRms rms aIn
	kRmsDiff = kRms - kLastRms
	
	kSmoothRms tonek kRms, 0.01
	
	kTime times
	
	if (kRmsDiff > iRmsDiffThreshold && kTime - kLastAttack > 0.05) then
		kLastAttack times
		pyrun "print 'clap detected', time.time()"
	endif
	
	printk2 kLastAttack
	
	aIn = 0.1 * aIn / a(kSmoothRms)

	;if (kRatio < 0.5) then
		;TODO: check time since last transient (attack)
	;	kLastDescent times
	;endif

	;printk2 kRms
	;printks "lastattack", 0.01, kLastAttack

	out aIn
	kLastRms = kRms
endin
</CsInstruments>
<CsScore>

i 1 0 50
e
</CsScore>
</CsoundSynthesizer>