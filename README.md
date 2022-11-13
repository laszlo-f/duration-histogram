# duration-histogram
Generates duration histograms from a time series and a threshold

This R program takes a time series and a threshold as input.  It outputs two histograms of durations.  The "on" durations are the number of time steps where the time series is above threshold. The "off" durations are the number of time steps where the time series is below threshold.  The R histogram algorithm is used with a log-transformed scale.  Statistical weights and error estimates are provided.
