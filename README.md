# bash-script

## **convergence-check.sh** is a bash script file checks if the energy and forces on a FLOSIC (Fermi–Löwdin self-interaction correction) calculations are converged. 


This shell script is checking the convergence of a simulation. The script has the following steps:

Deletes the files named pref, conv, and enfile if they exist.

Loops through all files with the extension .xyz in the current directory.

For each file, the prefix of the file is extracted by replacing the .xyz extension with an empty string.

If the file $prefix/fande.out exists, the script performs the following steps:
a. Writes the prefix to the file pref.
b. Extracts the last line from $prefix/fande.out and writes it to the file enfile.
c. Extracts the convergence values tt, t, mf, and de from the files $prefix/fande.out and $prefix/SUMMARY.
d. Checks if the simulation is converged by comparing the values of mf, de, tt, and t with the values of ftol, etol, z. If the simulation is converged, the script writes 'converged' and the value of tt to the file conv. If not, the script writes 'not-converged' to the file conv.

If the file $prefix/fande.out does not exist, the script performs the following steps:
a. Prints a message indicating that the file $prefix/fande.out does not exist.
b. Writes the prefix to the file pref.
c. Writes the values 0.0 0.0 0.0 to the file enfile.
d. Writes 'not-exist' to the file conv.

The script then combines the data in the files pref, enfile, and conv using paste and formats the data using awk, writing the resulting data to the file convergence.dat.

Finally, the script deletes the files pref, enfile, and conv.

## **get-energy.sh** produces an output file that gives the total energies and the atomization energies of the AE6 set. Atomization energies referrs to the energy required to break a molecule into its constituent atoms. 

This script analyzes energy data of different chemical compounds stored in SUMMARY files in different folders. It first calculates the energy values for different elements (H, C, O, S, Si) and stores them in a file named "total-energy.dat". Then, it calculates the binding energy of different chemical compounds (SiH4, SiO, S2, C2H2O2, C3H4, C4H8) based on the energy values of their constituent elements and stores them in a file named "ae.gsic.dat". The script then compares these calculated binding energies with reference values stored in a file named "ae6_ref_kcal.dat" and calculates the mean absolute error (MAE), mean error (ME), and mean absolute percentage error (MAPE). These values are stored in a file named "mae.gsic.dat". The script also performs some data processing tasks such as storing intermediate results in temporary files and then merging them to form the final result files.


## **Job script for slurm jobs**

This script is a submission script for the Slurm workload manager. It specifies the job requirements for running an FLOSIC-2020 code.

#SBATCH --time=24:00:00 sets the wall clock time limit of the job to 24 hours.

#SBATCH --ntasks=3 sets the number of tasks (nodes) needed for the job to 3.

#SBATCH --cpus-per-task=1 sets the number of CPUs (or cores) per task to 1.

#SBATCH --mem=5G sets the memory required per allocated CPU to 5 gigabytes.

#SBATCH --job-name prefix sets the job name to "prefix" for easier identification.

#SBATCH --mail-type=FAIL and #SBATCH --mail-type=END set the email notification to be sent if the job fails or ends, respectively.

#SBATCH --mail-user=email@email.com sets the email address to receive job updates.

module load intel/2019a loads the necessary Intel module for the code.

The script then changes to the directory where the code is located, but this line is commented out.

scontrol show job $SLURM_JOB_ID writes job information to the SLURM output file.

js -j $SLURM_JOB_ID is a Slurm command to check job status.

The script then enters a loop that runs the FLOSIC-2020/flosic/nrlmol_exe code and outputs the results to a file named "output.1". The code continues to run until either the force or energy tolerance is met, or the total number of steps has reached 500. The force tolerance is set to 0.0005, and the energy tolerance is set to 0.000001. If either tolerance is met, the loop terminates and the code outputs a message indicating that the FOD has been optimized to the desired accuracy.

## **Job submission for multiple files**

This script is a bash shell script that performs a series of actions on all files with the ".xyz" extension in the current working directory.

The script starts with a "for" loop that goes through all files with the ".xyz" extension in the current working directory. For each file, the following actions are performed:

The variable "prefix" is defined. This variable is created by removing the ".xyz" extension from the file name using the "sed" command.

The "sed" command is used to replace the string "prefix" in the "job.sh" script with the value of the "prefix" variable. This generates a new script with the name "job.sh" in a directory with the same name as the ".xyz" file.

The script changes to the directory created in step 2 using the "cd" command.

The "sbatch" command is used to submit the newly created "job.sh" script to a batch job scheduler for processing.

The script changes back to the original working directory using the "cd" command.

The loop then repeats for the next ".xyz" file in the current working directory.

This script is useful for processing multiple ".xyz" files in parallel using a batch job scheduler.
