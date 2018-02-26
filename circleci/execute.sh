export PATH="$HOME/miniconda3/bin:$PATH"
source activate vulc_analysis
export QBI_HOME=$(pwd)

python --version
python -c "import numpy; print('numpy %s' % numpy.__version__)"
python -c "import scipy; print('scipy %s' % scipy.__version__)"

# Generating documentation
for nb in */*ipynb; do
    jupyter nbconvert --ExecutePreprocessor.timeout=3600 --execute "$nb" --to markdown |& tee nb_to_md.txt
    traceback=$(grep "Traceback (most recent call last):" nb_to_md.txt)
    if [[ $traceback ]]; then
        exit 1
    fi
done

cd ~
mkdir -p ${HOME}/doc
mkdir -p ${HOME}/doc/notebooks
cp -r ${QBI_HOME}/notebooks/* ${HOME}/doc/notebooks
cp -r ./doc ${CIRCLE_ARTIFACTS}
