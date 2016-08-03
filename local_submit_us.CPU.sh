i=56
k=28 
n=0
while [ $i -le 60 ]
do
    r=$k.$n
    [ $i -le 9 ] && ip=0$i || ip=$i
    sed -e "s/XX/"$ip"/" mPFF2.r06.50.run00.in > test$ip.in
    sed -e "s/ZZ/"$r"/g" dist_06.50.rst > harmonic_$ip.in
    echo "#!/bin/bash 
#SBATCH --job-name=EAAAG_"$i"
#SBATCH --output=EAAAG_"$i".log 
#SBATCH --time=96:00:00 
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=20 
#SBATCH --exclusive

export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:/software/usr/gcc-4.9.2/lib64"
export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:/software/usr/hpcx-v1.2.0-292-gcc-MLNX_OFED_LINUX-2.4-1.0.0-redhat6.6/ompi-mellanox-v1.8/lib"
export AMBERHOME="/mnt/lustre_fs/users/mjmcc/apps/amber14"
export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:\$AMBERHOME/lib"" > submitjob$i.run01.sh
    echo "srun -N1 -n20 \$AMBERHOME/bin/pmemd.MPI -O -i test"$ip".in  -o EAAAG_"$ip".run01.log  -p EAAAG.prmtop -c EAAAG_"$ip".run00.rst  -r EAAAG_"$ip".run01.rst  -x EAAAG_"$ip".run01.mdcrd  -inf EAAAG_"$ip".run01.inf  -frc EAAAG_"$ip".run01.mdfrc" >> submitjob$i.run01.sh
    sbatch --dependency=afterok:18161 submitjob$i.run01.sh
    if [ $n == "0" ]
    then
	n=5
    else
	n=0
	k=`expr $k + 1`
    fi
    i=`expr $i + 1`
done


