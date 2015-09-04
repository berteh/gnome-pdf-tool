GPDFTool
================

Gnome GUI to edit PDF metadata (via pdftk).

Good alternatives: [PDFMtEd](https://github.com/Glutanimate/PDFMtEd) and [PDF Chain](http://pdfchain.sourceforge.net/).

Requirements
------------
- Gnome (GTK, pygtk> 2.6, python> 2.5)
- pdftk  (install with ``sudo apt-get install pdftk``)

Usage
-------
[Download](https://github.com/berteh/gnome-pdf-tool/archive/master.zip), decompress (for instance in ~/bin) and then

Either run from console (PDF input file is optional)

    cd <your GPDTFool download location> && ./Go_GPDFTool.sh [input.pdf]

Or install as a nautilus script, right click on a pdf file in nautilus and select ``Script > Edit PDF Metadata``

    cd <your GPDTFool download location>/nautilus-script/ && ./install_nautillus-script.sh && nautilus ~/.local/share/nautilus/scripts/ &

      
Features
---------
  - Edit metadata (InfosValues ​​& InfoKeys)
  - Rights Management
  - Password Management

Screenshot
---------
![GPDFTool interface](doc/screenshot.png)
  
Changelog
----------
2015/09/04

- Forked to github due to [Google Code](http://code.google.com/p/gnome-pdf-tool/) discontinuation
- update for Ubuntu 14.04

2012/04/04

- English translation added by Gayan - http://www.hecticgeek.com
- Working with Ubuntu Lucid 10.4
- New version of glade2script (2.4.3)

2010/08/04

- Initial French version for Ubuntu Hardy (8.04), by AnsuzPeorth - http://forum.ubuntu-fr.org/viewtopic.php?id=410841
