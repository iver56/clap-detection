class ClapAnalyzer:
    def __init__(self, pattern, deviation_threshold=0.1):
        """
        :param pattern: Relative time between the claps in the pattern. The lowest number must be 1.
        :param deviation_threshold: How much deviation from the pattern should be allowed
        :return:
        """
        self.buffer_size = len(pattern) + 1
        self.pattern = pattern
        self.pattern_sum = sum(pattern)
        self.min_pattern_time = .1 * self.pattern_sum  # min 100 ms between fastest clap in sequence
        self.max_pattern_time = .3 * self.pattern_sum  # max 300 ms between fastest clap in sequence
        self.clap_times = [None] * self.buffer_size
        self.deviation_threshold = deviation_threshold
        self.current_index = 0
        self.clap_listeners = set()
        self.clap_sequence_listeners = set()

    def on_clap(self, fn):
        self.clap_listeners.add(fn)

    def on_clap_sequence(self, fn):
        self.clap_sequence_listeners.add(fn)

    def clap(self, time):
        """
        Let the ClapAnalyzer know that a clap has been detected
        :param time: Number of seconds since the program started running. Must be float.
        :return:
        """
        for fn in self.clap_listeners:
            fn()

        self.current_index = self.wrap_around(self.current_index + 1)
        self.clap_times[self.current_index] = time

        first_clap_in_sequence = self.clap_times[self.current_index - self.buffer_size + 1]
        if first_clap_in_sequence is None:
            return  # waiting for more claps

        time_diff = time - first_clap_in_sequence
        avg_time_per_clap_unit = time_diff / self.pattern_sum
        if self.min_pattern_time <= time_diff <= self.max_pattern_time:
            total_deviation = 0
            j = 0
            for i in range(self.current_index - self.buffer_size + 1, self.current_index):
                clap_time_diff = self.clap_times[i + 1] - self.clap_times[i]
                relative_clap_time_diff = clap_time_diff / avg_time_per_clap_unit
                total_deviation += (relative_clap_time_diff - self.pattern[j]) ** 2
                j += 1

            if total_deviation < self.deviation_threshold:
                for fn in self.clap_sequence_listeners:
                    fn()
                return  # clap sequence detected!
            else:
                return  # clap sequence didn't match accurately enough with the pattern
        else:
            return  # clap sequence too short or too long

    def wrap_around(self, index):
        return index % self.buffer_size
