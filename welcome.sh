

if [ "$showdialog" == "true" ];then
echo "Welcome to Bash $BASH_VERSION" > test_textbox
#                  filename height width
whiptail --textbox test_textbox 12 80
fi

showdialog=false

echo "showdialog=$showdialog" > .new



