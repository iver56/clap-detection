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
	pyruni "from clap import ClapAnalyzer"
	pyruni "clap_analyzer = ClapAnalyzer(pattern=[2, 1, 1, 2], deviation_threshold=0.05)"
	pyruni "def clap_detected(): print 'Matching clap sequence detected!'"
	pyruni "clap_analyzer.on_clap(clap_detected)"
	
	kLastRms init 0
	kLastAttack init 0
	iRmsDiffThreshold init .1
	
	kTime times
	
	aIn in
	
	kRmsOrig rms aIn
	
	kSmoothingFreq linseg 5, 1, 0.01 ;quicker smoothing to start with
	kSmoothRms tonek kRmsOrig, kSmoothingFreq
	kSmoothRms max kSmoothRms, 0.0001
	
	aNorm = 0.1 * aIn / a(kSmoothRms)
	;aNorm butterbp aNorm, 12500, 2500
	
	kRms rms aNorm
	kRmsDiff = kRms - kLastRms
	
	if (kRmsDiff > iRmsDiffThreshold && kTime - kLastAttack > 0.09) then
		kLastAttack times
		;pyrun "clap_analyzer.clap()"
		pycall "clap_analyzer.clap", kLastAttack
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