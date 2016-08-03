i=19
k=9 
n=5
while [ $i -le 40 ]
do
    r=$k.$n
    [ $i -le 9 ] && ip=0$i || ip=$i
    sed -e "s/XX/"$ip"/" mPFF2.r06.50.run00.in > test$ip.in
    sed -e "s/ZZ/"$r"/g" dist_06.50.rst > harmonic_$ip.in
    echo "#!/bin/bash                                                                                                                                                                                                         
#SBATCH --job-name=EAAAG_"$i"                                                                                                                                                                                                
#SBATCH --output=EAAAG_"$i".log                                                                                                                                                                                               
#SBATCH --time=24:00:00                                                                                                                                                                                                       
#SBATCH --nodes=1                                                                                                                                                                                                             
#SBATCH --partition=mccullagh-gpu                                                                                                                                                                                             
#SBATCH --gres=gpu:titan:1                                                                                                                                                                                                     

export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:/software/usr/gcc-4.9.2/lib64"
export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:/software/usr/hpcx-v1.2.0-292-gcc-MLNX_OFED_LINUX-2.4-1.0.0-redhat6.6/ompi-mellanox-v1.8/lib"
export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:/usr/local/cuda-7.5/lib64"
export AMBERHOME="/mnt/lustre_fs/users/mjmcc/apps/amber14"
export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:\$AMBERHOME/lib"" > submitjob$i.sh
    echo "srun \$AMBERHOME/bin/pmemd.cuda -O -i test"$ip".in  -o EAAAG_"$ip".run00.log  -p EAAAG.prmtop -c EAAAG_"$ip".rst  -r EAAAG"$ip".run00.rst  -x EAAAG_"$ip".run00.mdcrd  -inf EAAAG_"$ip".run00.inf  -frc EAAAG_"$ip".run00.mdfrc" >> submitjob$i.sh
    sbatch submitjob$i.sh
    if [ $n == "0" ]
    then
	n=5
    else
	n=0
	k=`expr $k + 1`
    fi
    i=`expr $i + 1`
done


