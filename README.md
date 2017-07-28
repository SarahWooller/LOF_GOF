Identifying loss and gain of function driver missense mutations in cancer 

These scripts accompany the bioinformatics paper 
"Identifying loss and gain of function driver missense mutations in cancer" 
By Hanadi M Baeissa, Sarah K. Wooller, Chris J Richardson, and Frances M G Pearl  

To use the scripts:

Download and save “TrainingSet-27features.csv”. Change the first few lines of 
“LOF_GOF_trainer.R” to reflect where you’ve saved the training set and where you want to save the trained model to, before running the script.

Use the online tools: PolyPhen2, Fathmm Cancer, Fathmm Disease and NetsurfP to assemble data for the features as set out in the paper.

Change the first few lines of 
“LOF_GOF_predicter.R” to reflect where you’ve saved the trained model and where you want to save the predictions to before running the prediction script.

