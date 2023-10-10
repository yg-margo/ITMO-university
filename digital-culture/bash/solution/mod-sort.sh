mkdir -p data 
cp mod-sort.zip data 
cd data 
unzip -u -q mod-sort.zip 
rm -f mod-sort.zip 
cd .. 
for i in $(ls -t -r data/) 
do 
   cat data/$i >> data_all 
done 
sha256sum -b data_all
