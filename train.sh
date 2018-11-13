#/************************************************************************************
#***
#***	File Author: Dell, 2018-10-02 11:21:24
#***
#************************************************************************************/
#
#!/bin/bash
#
usage()
{
	echo "Usage: $0 <translate | transformer | textsum | imagecaption>"
	exit 1
}

translate()
{
	RUNNING_MODE="develop"
	TRAINING_MODE="second"

	if [ "${RUNNING_MODE}" = "develop" ] ; then
		DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/Translation/devdata"
	else
		DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/Translation/data"
	fi

	if [ "${TRAINING_MODE}" = "first" ] ; then
		python train.py \
			-gpuid 0 \
			-data ${DATA_DIR}/demo \
			-batch_size 32 \
			-train_steps 100000 \
			-save_model ${DATA_DIR}/demo-model

	else
		python train.py \
			-gpuid 0 \
			-data ${DATA_DIR}/demo \
			-batch_size 32 \
			-train_from ${DATA_DIR}/demo-model_step_100000.pt \
			-train_steps 200000 \
			-save_model ${DATA_DIR}/demo-model
	fi
}

transformer()
{
	RUNNING_MODE="develop"
	if [ "${RUNNING_MODE}" = "develop" ] ; then
		DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/Translation/devdata"
	else
		DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/Translation/data"
	fi

	python  train.py \
		-data ${DATA_DIR}/demo \
		-save_model ${DATA_DIR}/trans-model \
		-layers 6 \
		-rnn_size 512 \
		-word_vec_size 512 \
		-transformer_ff 2048 \
		-heads 8  \
		-encoder_type transformer \
		-decoder_type transformer \
		-position_encoding \
		-train_steps 100000  \
		-max_generator_batches 2 \
		-dropout 0.1 \
		-batch_size 4096 \
		-batch_type tokens \
		-normalization tokens \
		-accum_count 2 \
		-optim adam -adam_beta2 0.998 \
		-decay_method noam -warmup_steps 8000 -learning_rate 2 \
		-max_grad_norm 0 -param_init 0  -param_init_glorot \
		-label_smoothing 0.1 \
		-valid_steps 10000 \
		-save_checkpoint_steps 10000
		# -world_size 4 \
		# -gpu_ranks 0
}


textsum()
{
	DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/TextSum/LCSTS/DATA"

	python train.py \
		-gpuid 0 \
		-train_from demo-model_step_20000.pt \
		-data ${DATA_DIR}/demo \
		-save_model demo-model \
		-copy_attn \
		-global_attention mlp \
		-word_vec_size 128 \
		-rnn_size 512 \
		-layers 1 \
		-encoder_type brnn \
		-train_steps 100000 \
		-max_grad_norm 2 \
		-dropout 0. \
		-batch_size 16 \
		-optim adagrad \
		-learning_rate 0.15 \
		-adagrad_accumulator_init 0.1 \
		-reuse_copy_attn \
		-copy_loss_by_seqlength \
		-bridge \
		-seed 777
}

imagecaption()
{
	DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/ImageCaption/im2text"

	python train.py \
		-model_type img \
		-data ${DATA_DIR}/demo \
		-save_model demo-model \
		-gpuid 0 \
		-batch_size 4 \
		-max_grad_norm 20 \
		-learning_rate 0.1 \
		-word_vec_size 80 \
		-encoder_type brnn \
		-train_steps 100000

		# -image_channel_size 1
}

[ "$1" = "" ] && usage

eval $1
