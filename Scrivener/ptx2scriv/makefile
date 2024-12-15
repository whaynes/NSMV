SCRIVFILE = PreTeXt_Shell
PTXFILE = /Users/whaynes/ptx/IME/source/book.ptx
SAXON = /Applications/Oxygen\ XML\ Editor/frameworks/dita/DITA-OT3.x/lib/Saxon-HE-9.8.0-14.jar 

fixBinderItems:
	cd ~/ptx/ime/Scrivener/ptx2scriv  #switch to here
	textutil -convert rtf Data/*/content.txt    #turn text files to rtf
                  
	cp -r Data/* $(SCRIVFILE).scriv/Files/Data   #move all files to .scriv/Data
	rm $(SCRIVFILE).scriv/Files/Data/*/Content.txt  #get rid of text leftover text fle
# Put updated File references into DraftFolder of Binder
	xsltproc -o $(SCRIVFILE).scriv/$(SCRIVFILE).scrivx StuffBinder.xsl $(SCRIVFILE).scriv/$(SCRIVFILE).scrivx 
	#rm -r Data                                  #Get rid of temporary Data Dir
	
	ruby add_styles.rb PreTeXt_Shell.scriv/Files/Data/*/Content.rtf  #convert (some) tags to styles

files:
# UUID doesnt work with saxonHE
	java -jar $(SAXON) -xsl:ptx2scriv.xsl -xi:on -o:bind-out.xml -s:$(PTXFILE)
