This data set was created during a study by the Oxford Natural Interaction Lab (NIL) to investigate the internal and external workloads during a Yo-Yo intermittent recovery test.
This study was conducted between March and July 2023, under the ethics approval (R70833/RE001) granted by the Medical Sciences Interdivisional Research Ethics Committee of the University of Oxford. 
25 participants, between age 18-43, were recruited for this study, out of which 21 had agreed to have their data (including indirect identifiers - age, gender, height, and weight) published.
The participants were self-declared to be healthy and capable of carrying out intense activities stated in the experimental protocol.
The participants each attended two data capture sessions under the same protocol scheduled on different dates. 
Any data with curraption and unremovable artifacts, either due to catastrophic equipment failure or extreme environmental factors, had been removed from the data set during preprocessing.
The data set was split into two subsites, one for each round of data capture, under folders labelled as "FirstRound" and "SecondRound". 
Under each subset folder, the data is further devided into individual folders for each participant. 
Each subset folder also contains a metadata.csv file, breaking down the details of data contain within each subset. 
Inside each participant's folder, there is a .csv file containing Breath-by-Breath (BxB) metabolic data and GPS data recorded via a COSMED K5 (COSMED, Rome, Italy). 
If a participant agreed to wearing a heart rate strap, the participant was provided with a Polar H10 (Polar Electro Oy, Kempele, Finland). 
The heart rate data was then transmitted to the COSMED K5, and exported as a part of the COSMED K5 .csv file.
Inside each participant's folder, there's also a .csv file containing the timestamps for the Yo-Yo test levels and the participant's Rating of Perceived Exertion (RPE) at that level.
If the participant conscented to have their audio taken, they were also equiped with a mircophone instrumented mouthguard (Cheng and Bergmann, 2022).
The audio data is then exported asa .wav file have stored under the participant's folder.
Lastly, to load the data, please make use of the provided python3 and MATLAB scripts.

Brief outline of the data under each data subset:
FirstRound: COSMED and RPE data from 21 participants, 18 of which included heartrate; 144 mins of audio data from 19 participants.
SecondRound: COSMED and RPE data from 19 participants, 18 of which included heartrate; 134 mins of audio data from 13 participants.

What do the metadata files contain:


ID
Gender
Age
Height: measured in cm, this value was self-reported by the participant
Weight: measured in kg, this value was self-reported by the participant
Barometric Pressure: measured in mmHg, this value was recorded by the COSMED K5's onboard barometer
Ambient Temperature: measured in °C, this value was recorded by the COSMED K5's onboard thermocouple
Ambient Relative Humidity: measured in %, this value was recorded by the COSMED K5's onboard hygrometers
COSMED File Name: name of the COSMED data file
Heart Rate Included?: a binary value; 1 means the corresponding COSMED data contains heart rate, and 0 means otherwise
YoYo Test Start Time: timestamp, measured in seconds, of the start of the Yo-Yo test for the COSMED data	
YoYo Test Start Index: COSMED datapoint index of the start of the Yo-Yo test (the first entry in the COSMED file is indexed as 1)
YoYo Test End Time: timestamp, measured in seconds, of the end of the Yo-Yo test for the COSMED data
YoYo Test End Index: COSMED datapoint index of the end of the Yo-Yo test (the first entry in the COSMED file is indexed as 1)
Note: any complications with the Yo-Yo test, such as a pause or a restart
RPE File Name: name of the csv file of RPE levels recored at the start and finish of each Yo-Yo test level
Session RPE
YoYo Test Level	Audio Included?: a binary value; 1 means there is respiratory audio data for the participant, and 0 means otherwise
Audio File Name: name of the respiratory audio data file, if included
