<CsoundSynthesizer>
<CsOptions>
-iadc
--nosound
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs  = 1

pyinit

instr 1
	pyruni "from clap import ClapAnalyzer"
	pyruni "clap_analyzer = ClapAnalyzer(note_lengths=[0.25, 0.125, 0.125, 0.25, 0.25])"
	pyruni "def clap_detected(): print 'Clap detected'"
	pyruni "def clap_sequence_detected(): print 'Matching clap sequence detected!'"
	pyruni "clap_analyzer.on_clap(clap_detected)"
	pyruni "clap_analyzer.on_clap_sequence(clap_sequence_detected)"
	
	kLastRms init 0
	kLastAttack init 0
	iRmsDiffThreshold init .1
	
	kTime times
	
	aIn in
	
	kRmsOrig rms aIn
	
	kSmoothingFreq linseg 5, 1, 0.01 ;quicker smoothing to start with
	kSmoothRms tonek kRmsOrig, kSmoothingFreq
	kSmoothRms max kSmoothRms, 0.001
	
	aNorm = 0.1 * aIn / a(kSmoothRms)
	
	kRms rms aNorm
	kRmsDiff = kRms - kLastRms
	
	if (kRmsDiff > iRmsDiffThreshold && kTime - kLastAttack > 0.09) then
		kLastAttack times
		pycall "clap_analyzer.clap", kLastAttack
	endif

	out aNorm
	kLastRms = kRms
endin
</CsInstruments>
<CsScore>

i 1 0 5000
e
</CsScore>
</CsoundSynthesizer>
