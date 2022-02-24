# NB-SQI
A non-binary signal quality index for continuous blood pressure waveforms

### Introduction
The objective of this code is to measure the quality of continuous blood pressure signals. The definition of NB-SQI is based on the features derived from the signal, measuring their abnormalities and their normalised deviation from an expected value. The NB-SQI determined as a value from the 0-5 interval, where 0 means poor quality, and 5 corresponds to good quality. The non-binary manner of the index makes it available for various applications because thresholds and quality categories can be defined for the different measurement methods and purposes.

### Running
- Quality of a heart-cycle long signal: `sqi_period.m`
- Quality of longer signal: `sqi_measure.m`

### Reference
Ignacz, A., Földi, S., Sotonyi, P., & Cserey, G. (2021). NB-SQI: A novel non-binary signal quality index for continuous blood pressure waveforms. Biomedical Signal Processing and Control, 70, 103035.
https://doi.org/10.1016/j.bspc.2021.103035
