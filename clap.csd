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
	iRmsDiffThreshold init .1
	
	aIn in
	
	kRmsOrig rms aIn
	kSmoothRms tonek kRmsOrig, 0.01
	kSmoothRms max kSmoothRms, 0.0001
	
	aNorm = 0.1 * aIn / a(kSmoothRms)
	
	kRms rms aNorm
	kRmsDiff = kRms - kLastRms
	
	kTime times
	
	if (kRmsDiff > iRmsDiffThreshold && kTime - kLastAttack > 0.05) then
		kLastAttack times
		pyrun "print 'clap detected', time.time()"
	endif

	out aNorm
	kLastRms = kRms
endin
</CsInstruments>
<CsScore>

i 1 0 50
e
</CsScore>
</CsoundSynthesizer>