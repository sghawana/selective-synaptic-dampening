# Task bash files to be called by the overall bash file for all experiments of the specified model type.
# We provide all of the individual bash files per task and model to make individual experiments easy to call.

reset_cuda(){
    sleep 10    
}

DEVICE=$1
seed=$2
#############################################################
################ CIFAR20 SUBCLASS FORGETTING ################
#############################################################
#declare -a StringArray=("rocket" "mushroom" "baby" "lamp" "sea") # classes to iterate over
declare -a StringArray=("rocket")

dataset=Cifar20
n_superclasses=20
n_subclasses=100

weight_path=/home/mtech1/selective-synaptic-dampening/src/checkpoint/ResNet18/Wednesday_14_August_2024_11h_24m_35s/ResNet18-Cifar20-40-best.pth

for val in "${StringArray[@]}"; do
    forget_class=$val
    # Run the Python script
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_subclass_main.py -net ResNet18 -dataset $dataset -superclasses $n_superclasses -subclasses $n_subclasses -gpu -method baseline -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_subclass_main.py -net ResNet18 -dataset $dataset -superclasses $n_superclasses -subclasses $n_subclasses -gpu -method ssd_tuning -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_subclass_main.py -net ResNet18 -dataset $dataset -superclasses $n_superclasses -subclasses $n_subclasses -gpu -method finetune -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_subclass_main.py -net ResNet18 -dataset $dataset -superclasses $n_superclasses -subclasses $n_subclasses -gpu -method amnesiac -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_subclass_main.py -net ResNet18 -dataset $dataset -superclasses $n_superclasses -subclasses $n_subclasses -gpu -method blindspot -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_subclass_main.py -net ResNet18 -dataset $dataset -superclasses $n_superclasses -subclasses $n_subclasses -gpu -method UNSIR -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
    CUDA_VISIBLE_DEVICES=$DEVICE python forget_subclass_main.py -net ResNet18 -dataset $dataset -superclasses $n_superclasses -subclasses $n_subclasses -gpu -method retrain -forget_class $forget_class -weight_path $weight_path -seed $seed
    reset_cuda
done