#!/bin/sh
i=6
k=3 
n=0
while [ $i -le 40 ]
do
    r=$k.$n
    [ $i -le 9 ] && ip=0$i || ip=$i
    sed -e "s/XX/"$ip"/" mPFF2.r06.50.run00.in > test$ip.run00.in
    sed -e "s/XX/"$ip"/" mPFF2.r06.50.run01.in > test$ip.run01.in
    sed -e "s/XX/"$ip"/" mPFF2.r06.50.run02.in > test$ip.run02.in
    sed -e "s/ZZ/"$r"/g" dist_06.50.rst > harmonic_$ip.in
    echo "#!/bin/bash
#SBATCH --job-name="EAAAG_$ip"                                                                                                                                      
#SBATCH --output="EAAAG_$ip.log"                                                                                                                                   
#SBATCH --partition=compute                                                                                                                                           
#SBATCH --nodes=1                                                                                                                                                     
#SBATCH --ntasks-per-node=24                                                                                                                                          
#SBATCH --export=ALL                                                                                                                                                  
#SBATCH -t 48:00:00                                                                                                                                                  
                                                          


module load amber

cd '/oasis/scratch/comet/rnw8253/temp_project/EAAAG/'
" > submitjob$i.run02.sh
    echo "ibrun pmemd.MPI -O -i test"$ip".run02.in  -o EAAAG_"$ip".run03.log  -p EAAAG.prmtop -c EAAAG_"$ip".run01.rst  -r EAAAG_"$ip".run02.rst  -x EAAAG_"$ip".run02.mdcrd  -inf EAAAG_"$ip".run02.inf  -frc EAAAG_"$ip".run02.mdfrc" >> submitjob$i.run02.sh
    sbatch submitjob$i.run02.sh
    if [ $n == "0" ]
    then
	n=5
    else
	n=0
	k=`expr $k + 1`
    fi
    i=`expr $i + 1`
done


