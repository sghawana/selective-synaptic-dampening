# Task bash files to be called by the overall bash file for all experiments of the specified model type.
# We provide all of the individual bash files per task and model to make individual experiments easy to call.

reset_cuda(){
    sleep 10    
}

DEVICE=$1
seed=$2
#############################################################
################ CIFAR20 VEHICLE FORGETTING #################
#############################################################
#declare -a StringArray=("vehicle2" "veg" "people" "electrical_devices" "natural_scenes" ) # classes to iterate over
declare -a StringArray=("vehicle2")
dataset=Cifar20
n_classes=20
weight_path=/home/mtech1/selective-synaptic-dampening/src/checkpoint/ResNet18/Wednesday_14_August_2024_11h_24m_35s/ResNet18-Cifar20-40-best.pth

for val in "${StringArray[@]}"; do
    forget_class=$val
    # Run the Python script
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ResNet18 -dataset $dataset -classes $n_classes -gpu -method baseline -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ResNet18 -dataset $dataset -classes $n_classes -gpu -method ssd_tuning -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ResNet18 -dataset $dataset -classes $n_classes -gpu -method finetune -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ResNet18 -dataset $dataset -classes $n_classes -gpu -method amnesiac -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ResNet18 -dataset $dataset -classes $n_classes -gpu -method blindspot -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ResNet18 -dataset $dataset -classes $n_classes -gpu -method UNSIR -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ResNet18 -dataset $dataset -classes $n_classes -gpu -method retrain -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
done