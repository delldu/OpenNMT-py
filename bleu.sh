#/************************************************************************************
#***
#***	File Author: Dell, 2018-10-02 11:21:24
#***
#************************************************************************************/
#
#!/bin/bash
#

translate()
{
	DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/Translation/data"

	# python translate.py \
	# 	-gpu 0 \
	# 	-model \
	# 	${DATA_DIR}/demo-model_step_100000.pt \
	# 	-src ${DATA_DIR}/valid.en \
	# 	-tgt ${DATA_DIR}/valid.zh \
	# 	-output pred.txt \
	# 	-replace_unk \
	# 	-report_bleu \
	# 	-verbose
}


textsum()
{
	DATA_DIR="/home/dell/ZDisk/WorkSpace/relay/examples/TextSum/LCSTS/DATA"

	python baseline.py -s pred.txt -t ${DATA_DIR}/valid.txt.tgt -m no_sent_tag -r
}

textsum
