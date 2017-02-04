# clap-detection
Clap sequence/rhythm/pattern detection on Raspberry Pi using Csound and Python

## Why

Some examples of things you can have your Raspberry Pi do when a matching clap sequence is detected:

* Dim the lights and start playing smooth jazz music
* Turn on/off the TV
* Broadcast a yo
* Project the weather forecast on the wall

## How

Csound takes in audio from a microphone live and checks the audio for transients. Whenever a transient (rapidly ascending amplitude) is detected, Csound will notice ClapAnalyzer, a class implemented in Python. ClapAnalyzer looks for a specific rhytmic clap sequence. ClapAnalyzer will notice all listeners whenever a matching clap sequence is detected.

## Usage

### Python

Let's use the following rhythmic sequence as example:

![clap](https://cloud.githubusercontent.com/assets/1470603/9700905/a6de8d6a-5415-11e5-81f6-f81e4034a939.png)

The note lengths are 1/4, 1/8, 1/8, 1/4, 1/4, so we set the `note_lengths` parameter to [0.25, 0.125, 0.125, 0.25, 0.25].

```python
from clap import ClapAnalyzer

clap_analyzer = ClapAnalyzer(note_lengths=[0.25, 0.125, 0.125, 0.25, 0.25])

def clap_sequence_detected():
  print 'Matching clap sequence detected!'

clap_analyzer.on_clap_sequence(clap_sequence_detected)

# You can now start calling clap_analyzer.clap(time)
```

Basically, this is the python code that is used in `clap.csd`

### Csound

Start csound from your command line. By default, the csound instrument will get live audio input:

`csound clap.csd`

If you want to quickly analyze a wav file, you can use that file instead of live audio input. This is good for testing:

`csound clap.csd -i myfile.wav`

PS: The file must be mono, not stereo, for this to work. And if your sound file is long, then you should modify the amount of time the Csound instrument stays alive accordingly, in order to analyze the whole file.

## Troubleshooting

### "no module named clap"

Try adding the directory with the python module dynamically:

```
pyruni "import sys, os"
pyruni "sys.path.append('/path/to/clap-detection')"
```

Edit `/path/to/clap-detection` to the place where clap.py is located.

### "Segmentation fault" or "Unable to set number of channels on soundcard"

Check if your input device is mono or stereo. If it is mono (i.e. has only one channel), then you should set `nchnls = 1` in your csound file, and you should use the `in` opcode instead of `ins`. If your input device is stereo, then you should set `nchnls = 2`.

### ALSA and/or PortAudio warnings

Use the `-+rtaudio=alsa` option

### Stuttering/crackling/noise/"Buffer underrun"

Let Csound use a large buffer in both software and hardware. In other word, use the following options: `-b2048 -B2048`

### Input device error

Run `arecord -l` and check the list of sound cards and subdevices that are available. If you, for example, want to use card 1, subdevice 0, then you should use the following csound option: `-i adc:hw:1,0`
