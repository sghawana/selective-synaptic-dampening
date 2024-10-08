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
declare -a StringArray=("vehicle2" "veg" "people" "electrical_devices" "natural_scenes" ) # classes to iterate over

dataset=Cifar20
n_classes=20
b_size=64
weight_path= # Add the path to your ViT weights

for val in "${StringArray[@]}"; do
    forget_class=$val
    # Run the Python script
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ViT -dataset $dataset -classes $n_classes -gpu -b $b_size -method blindspot -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ViT -dataset $dataset -classes $n_classes -gpu -b $b_size -method baseline -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ViT -dataset $dataset -classes $n_classes -gpu -b $b_size -method ssd_tuning -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ViT -dataset $dataset -classes $n_classes -gpu -b $b_size -method finetune -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ViT -dataset $dataset -classes $n_classes -gpu -b $b_size -method amnesiac -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ViT -dataset $dataset -classes $n_classes -gpu -b $b_size -method UNSIR -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_full_class_main.py -net ViT -dataset $dataset -classes $n_classes -gpu -b $b_size -method retrain -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
done