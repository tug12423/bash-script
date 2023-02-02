# bash-script

**convergence-check.sh** is a bash script file checks if the energy and forces on a FLOSIC (Fermi–Löwdin self-interaction correction) calculations are converged. 


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

**get-energy.sh** produces an output file that gives the total energies and the atomization energies of the AE6 set. Atomization energies referrs to the energy required to break a molecule into its constituent atoms. 
