i=6
k=3 
n=0
while [ $i -le 6 ]
do
    r=$k.$n
    [ $i -le 9 ] && ip=0$i || ip=$i
    sed -e "s/XX/"$ip"/" mPFF2.r06.50.run00.in > test$ip.in
    sed -e "s/ZZ/"$r"/g" dist_06.50.rst > harmonic_$ip.in
    echo "#!/bin/bash 
#SBATCH --job-name=EAAAG_"$i"
#SBATCH --output=EAAAG_"$i".log 
#SBATCH --partition=compute 
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=20 
#SBATCH --export=all                                                                                                                                                                                                            #SBATCH -t 24:00:00 

module load amber/15

cd '/oasis/scratch/comet/rnw8253/temp_project/meta'" > submitjob$i.sh
    echo "
ibrun -N1 -n20 \$AMBERHOME/bin/pmemd.MPI -O -i test"$ip".in  -o EAAAG_"$ip".run00.log  -p EAAAG.prmtop -c EAAAG_"$ip".rst  -r EAAAG_"$ip".run00.rst  -x EAAAG_"$ip".run00.mdcrd  -inf EAAAG_"$ip".run00.inf  -frc EAAAG_"$ip".run00.mdfrc" >> submitjob$i.sh
    if [ $n == "0" ]
    then
	n=5
    else
	n=0
	k=`expr $k + 1`
    fi
    i=`expr $i + 1`
done


