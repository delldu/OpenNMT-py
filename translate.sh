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
	echo "Usage: $0 [options] <translate | textsum | imagecaption>"	exit 1
}


translate()
{
	RUNNING_MODE="developX"

	if [ "${RUNNING_MODE}" = "develop" ] ; then
		DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/Translation/devdata"
	else
		DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/Translation/data"
	fi

	python translate.py \
		-gpu 0 \
		-model ${DATA_DIR}/demo-model_step_100000.pt \
		-src ${DATA_DIR}/valid.en \
		-tgt ${DATA_DIR}/valid.zh \
		-report_bleu \
		-output pred.txt \
		-replace_unk \
		-verbose
}



textsum()
{
	DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/TextSum/LCSTS/DATA"

	python translate.py \
		-gpu 0 \
		-batch_size 20 \
		-beam_size 5 \
		-model ${DATA_DIR}/demo-model_step_100000.pt \
		-src ${DATA_DIR}/valid.txt.src \
		-output pred.txt \
		-min_length 35 \
		-verbose \
		-stepwise_penalty \
		-coverage_penalty summary \
		-beta 5 \
		-length_penalty wu \
		-alpha 0.9 \
		-verbose \
		-block_ngram_repeat 3 \
		-ignore_when_blocking "." "</t>" "<t>"
}

imagecaption()
{
	DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/ImageCaption/im2text"

	python translate.py \
		-data_type img \
		-model demo-model_acc_x_ppl_x_e13.pt \
		-src_dir ${DATA_DIR}/images \
		-src ${DATA_DIR}/src-test.txt \
		-output pred.txt \
		-beam_size 5 \
		-gpu 0 \
		-verbose		
}

[ "$1" = "" ] && usage

eval $1
