unzip -q -u word-count.zip 
find _zzAnTfyVDg -name "*$(cat target.word)*" -execdir wc -w \{\} \; > wc.txt 
total=0 
while read -r line 
do 
  wc=$(echo $line|cut -f 1 -d ' ') 
  let total=$total+$wc 
done < wc.txt 
echo $total
