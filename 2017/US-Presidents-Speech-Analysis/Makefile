
IPYNB_FILES=$(wildcard state_of_the_union_analysis-p*.ipynb)



.PHONY : env
env: environment.yml
	conda env create -f environment.yml

.PHONY: all
all: $(IPYNB_FILES)
	jupyter nbconvert --ExecutePreprocessor.timeout=-1 --inplace --execute state_of_the_union_analysis-p1.ipynb
	jupyter nbconvert --ExecutePreprocessor.timeout=-1 --inplace --execute state_of_the_union_analysis-p2.ipynb
	jupyter nbconvert --ExecutePreprocessor.timeout=-1 --inplace --execute state_of_the_union_analysis-p3.ipynb
	jupyter nbconvert --ExecutePreprocessor.timeout=-1 --inplace --execute state_of_the_union_analysis-p4.ipynb
	jupyter nbconvert --ExecutePreprocessor.timeout=-1 --inplace --execute state_of_the_union_analysis-p5.ipynb
	jupyter nbconvert --ExecutePreprocessor.timeout=-1 --inplace --execute main.ipynb
