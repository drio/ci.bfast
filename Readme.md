# ci.bfast - continuous integration for bfast

  There has been some emails in the
  [Bfast](http://sourceforge.net/apps/mediawiki/bfast/index.php?title=Main_Page)
  user mailing list where users complained about the testing cases and the 
  building process breaking up. 

  This little project pretends to alleviate that by detecting issues in the
  building process as new commits happen in the different branches.

  The software monitors the different branches and when a new commit is
  detected, a full compilation process is fired up. All the stdout is logged to
  a file and posted online. If anything goes wrong, a warning will be showed in
  the compilation page.

  One cool feature is that the compilation happens in different virtual
  machines. In that way we can ensure we test the process in as many different 
  environments as possible. We'll start with Darwin, ubuntu32 and ubuntu64
  bits.

## How does it work?

  The heavy lifting is done by [chef](http://en.wikipedia.org/wiki/Chef_(software))
  and [Vagrant](http://vagrantup.com/). Vagrant is a tool for building virtual
  machines programmatically. This tool relies on Sun's (Oracle now) [virtualbox] 
  virtualization product.  Chef is a framework to provision boxes programmatically.

  Our tool uses the features of all these tools to programmatically implement
  what we described in the introduction.

## Give me the details.

  For the moment, read the code. :)
  
