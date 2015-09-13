# clap-detection
Clap sequence detection on Raspberry Pi using Csound and Python

## How

Csound takes in audio from a microphone live and checks the audio for transients. Whenever a transient (rapidly ascending amplitude) is detected, Csound will notice ClapAnalyzer, a class implemented in Python. ClapAnalyzer looks for a specific rhytmic clap sequence. ClapAnalyzer will notice all listeners whenever a matching clap sequence is detected.

## Usage

For example, let's use the following rhythmic sequence as example:

![clap](https://cloud.githubusercontent.com/assets/1470603/9700905/a6de8d6a-5415-11e5-81f6-f81e4034a939.png)

The relative time between each clap is: [2, 1, 1, 2]

```python
from clap import ClapAnalyzer

clap_analyzer = ClapAnalyzer(
  pattern=[2, 1, 1, 2],
  deviation_threshold=0.05
)

def clap_detected():
  print 'Matching clap sequence detected!'

clap_analyzer.on_clap(clap_detected)
```

## Why

Some examples of things you can have your Raspberry Pi do when a matching clap sequence is detected:

-Dim the lights and start playing smooth jazz music
-Turn on/off the TV
-Broadcast a yo
-Project the weather forecast on the wall
