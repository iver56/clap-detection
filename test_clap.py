import unittest
from clap import ClapAnalyzer


class TestClapAnalyzer(unittest.TestCase):
    def setUp(self):
        self.clap_analyzer = ClapAnalyzer(
            note_lengths=[1./4, 1./8, 1./8, 1./4, 1./4],
            deviation_threshold=0.1
        )
        self.clap_analyzer.on_clap_sequence(self.clap_sequence_callback)
        self.num_clap_sequences_detected = 0

    def clap_sequence_callback(self):
        self.num_clap_sequences_detected += 1
        return None

    def test_scenario1(self):
        self.clap_analyzer.clap(0.414)
        self.clap_analyzer.clap(0.660)
        self.clap_analyzer.clap(0.796)
        self.clap_analyzer.clap(0.905)
        self.assertEquals(self.num_clap_sequences_detected, 0)
        self.clap_analyzer.clap(1.155)
        self.assertEquals(self.num_clap_sequences_detected, 1)

    def test_scenario2(self):
        self.clap_analyzer.clap(0.617)
        self.clap_analyzer.clap(0.984)
        self.clap_analyzer.clap(1.163)
        self.clap_analyzer.clap(1.355)
        self.assertEquals(self.num_clap_sequences_detected, 0)
        self.clap_analyzer.clap(1.724)
        self.assertEquals(self.num_clap_sequences_detected, 1)

        self.clap_analyzer.clap(2.899)
        self.clap_analyzer.clap(3.224)
        self.clap_analyzer.clap(3.416)
        self.clap_analyzer.clap(3.608)
        self.assertEquals(self.num_clap_sequences_detected, 1)
        self.clap_analyzer.clap(3.967)
        self.assertEquals(self.num_clap_sequences_detected, 2)

        self.clap_analyzer.clap(4.645)
        self.clap_analyzer.clap(5.016)

    def test_scenario3(self):
        self.clap_analyzer.clap(0.0101)

        self.clap_analyzer.clap(0.689)
        self.clap_analyzer.clap(0.984)
        self.clap_analyzer.clap(1.094)
        self.clap_analyzer.clap(1.458)
        self.clap_analyzer.clap(1.663)
        self.clap_analyzer.clap(1.880)

        self.clap_analyzer.clap(4.307)
        self.clap_analyzer.clap(4.499)
        self.clap_analyzer.clap(4.494)
        self.clap_analyzer.clap(4.907)
        self.clap_analyzer.clap(4.907)
        self.clap_analyzer.clap(5.114)
        self.clap_analyzer.clap(5.511)

        self.assertEquals(self.num_clap_sequences_detected, 0)


if __name__ == '__main__':
    unittest.main()
