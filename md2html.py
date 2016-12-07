#!/usr/bin/env python
import codecs
import markdown

input_file = codecs.open("BrightCM_TrainingNotes_continued.md", mode="r", encoding="utf-8")
text = input_file.read()
html = markdown.markdown(text)

output_file = codecs.open("BrightCM_TrainingNotes_continued.html", "w",
                            encoding="utf-8",
                            errors="xmlcharrefreplace"
)
output_file.write(html)
