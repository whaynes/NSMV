#usr/bin/ruby
patterns = [{pattern:
                 '{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf500
{\fonttbl\f0\fswiss\fcharset0 Helvetica-Light;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}',
             replacement:
                 "{\\rtf1\\ansi\\ansicpg1252\\cocoartf1671\\cocoasubrtf500\n{\\fonttbl\\f0\\fmodern\\fcharset0 Courier;\\f1\\fswiss\\fcharset0 Helvetica;\\f2\\fmodern\\fcharset0 Courier-Bold;\n\\f3\\fmodern\\fcharset0 Courier-Oblique;\\f4\\froman\\fcharset0 TimesNewRomanPSMT;}\n{\\colortbl;\\red255\\green255\\blue255;\\red76\\green0\\blue6;\\red179\\green179\\blue179;\\red0\\green0\\blue0;\n\\red255\\green255\\blue255;\\red7\\green69\\blue205;\\red230\\green230\\blue230;\\red26\\green26\\blue26;\\red85\\green140\\blue52;\n\\red155\\green155\\blue155;\\red16\\green128\\blue214;\\red113\\green55\\blue249;}\n{\\*\\expandedcolortbl;;\\cssrgb\\c37300\\c1200\\c1600;\\csgray\\c75300;\\csgray\\c0;\n\\csgray\\c100000;\\cssrgb\\c0\\c36900\\c84300;\\csgray\\c92200;\\csgray\\c13700;\\cssrgb\\c40000\\c60800\\c26300;\n\\csgray\\c67100;\\csgenericrgb\\c6100\\c50000\\c84000;\\cssrgb\\c52500\\c34100\\c98400;}\n\\f0\\fs28\\sb240\\cf3"},
            {pattern: '<p>', replacement: "\\pard\\plain<$Scr_Ps::0>\\f0\\fs28\\sb240"},
            {pattern: '</p>\\', replacement: "\\\n\\pard\\plain<!$Scr_Ps::0>\\f0\\fs28\\sb240\\cf3"},
            {pattern: '<!--', replacement: "\\pard\\plain<$Scr_Ps::1>\\f1\\fs28\\cf9\\sb240"},
            {pattern: / ?-->\\/, replacement: "\\\n\\pard\\plain<!$Scr_Ps::1>\\f0\\fs28\\sb240\\cf3"},
            {pattern: '<m>', replacement: "\\cf6\\cb7<$Scr_Cs::9>\\f0\\fs28 "},
            {pattern: '</m>', replacement: "<!$Scr_Cs::9>\\plain\\fs28\\sb240\\ "}]

ARGV.each do |f|
  content = File.read(f)
  patterns.each do |p|
    content.gsub!(p[:pattern], p[:replacement])
  end
  puts f
  File.write(f, content)
end
