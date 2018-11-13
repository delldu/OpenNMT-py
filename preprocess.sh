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
	echo "Usage: $0 <translate | textsum | imagecaption>"
	exit 1
}

translate()
{
	RUNNING_MODE="develop"

	if [ "${RUNNING_MODE}" = "develop" ] ; then
		DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/Translation/devdata"
	else
		DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/Translation/data"
	fi

	python preprocess.py \
		-train_src ${DATA_DIR}/train.en \
		-train_tgt ${DATA_DIR}/train.zh \
		-valid_src ${DATA_DIR}/valid.en \
		-valid_tgt ${DATA_DIR}/valid.zh \
		-save_data ${DATA_DIR}/demo \
		-max_shard_size 134217728
}

textsum()
{
	DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/TextSum/LCSTS/DATA"

	python preprocess.py \
		-train_src ${DATA_DIR}/train.txt.src \
		-train_tgt ${DATA_DIR}/train.txt.tgt \
    	-valid_src ${DATA_DIR}/valid.txt.src \
    	-valid_tgt ${DATA_DIR}/valid.txt.tgt \
    	-save_data ${DATA_DIR}/demo \
    	-max_shard_size 134217728 \
		-src_seq_length 10000 \
		-tgt_seq_length 10000 \
		-src_seq_length_trunc 400 \
		-tgt_seq_length_trunc 100 \
		-dynamic_dict \
		-share_vocab
}

imagecaption()
{
	DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/ImageCaption/im2text"

	python preprocess.py \
		-data_type img \
		-src_dir ${DATA_DIR}/images/ \
		-train_src ${DATA_DIR}/src-train.txt \
		-train_tgt ${DATA_DIR}/tgt-train.txt \
		-valid_src ${DATA_DIR}/src-val.txt \
		-valid_tgt ${DATA_DIR}/tgt-val.txt \
		-save_data ${DATA_DIR}/demo \
		-max_shard_size 134217728 \
		-tgt_seq_length 150 \
		-tgt_words_min_frequency 2 

		# -shard_size 500
		# -image_channel_size 1
}

[ "$1" = "" ] && usage

eval $1
