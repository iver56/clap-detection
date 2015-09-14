# clap-detection
Clap sequence detection on Raspberry Pi using Csound and Python

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

For example, let's use the following rhythmic sequence as example:

![clap](https://cloud.githubusercontent.com/assets/1470603/9700905/a6de8d6a-5415-11e5-81f6-f81e4034a939.png)

In this sequence, the time between the first and the second clap is twice the time between the second and the third clap. You get it. Hence the relative times between the claps are [2, 1, 1, 2], and this is what we set our `pattern` variable to. The smallest number in the pattern should be 1.

```python
from clap import ClapAnalyzer

clap_analyzer = ClapAnalyzer(pattern=[2, 1, 1, 2])

def clap_detected():
  print 'Matching clap sequence detected!'

clap_analyzer.on_clap(clap_detected)

# You can now start calling clap_analyzer.clap(time)
```

### Csound

Start csound from your command line. By default, the csound instrument will get live audio input:

`csound clap.csd --nosound`

If you want to quickly analyze a wav file, you can use that file instead of live audio input. This is good for testing:

`csound clap.csd -i myfile.wav --nosound`

PS: The file must be mono, not stereo, for this to work. And if your sound file is long, then you should modify the amount of time the Csound instrument stays alive accordingly, in order to analyze the whole file.
