CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

files=`find student-submission`
if ! [[ -f student-submission/ListExamples.java ]]
then
        echo 'Missing ListExamples.java'
fi

cp ./student-submission/ListExamples.java ./grading-area
cp TestListExamples.java ./grading-area
cp -r lib grading-area

cd grading-area
javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java

if [[ $? == 0 ]]
then
    java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > test-results.txt
    grep -i 'Tests run: ' test-results.txt > score-result.txt
    if [[ -s score-result.txt ]]
    then
        egrep -o "[0-9]+" score-result.txt > score-parsed.txt
        result=(`cat score-parsed.txt`)
        total=${result[1]}
        fail=${result[0]}
        success=$(($total-$fail))
        echo 'Your score is:' $(($(($success*100))/$total))
    else
        echo 'Your score is: 100'
    fi
else
    echo 'Compilation failure'
fi



# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
