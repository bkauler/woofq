#!/usr/bin/env python

#  fpm2keepass.py: Convert FPM password XML to KeePass/KeePassX XML
#  Copyright (C) 2010 Dan Scott <dan@coffeecode.net>
#  Command line contribution by Simon Oosthoek <s.oosthoek@xs4all.nl>
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.


#  Iterate over PasswordItem
#  
#  * PasswordItem -> pwentry
#    * title -> title
#    * category -> group
#    * user -> username
#    * url -> url
#    * password -> password
#    * notes -> notes
#    * () -> uuid
#    * () -> creationtime
#    * () -> lastmodtime
#    * () -> lastaccesstime
#    * () -> expiretime
#    * () -> image

import codecs
import sys
import os.path
import xml.sax
import xml.sax.handler

class KeePass2:
  def __init__(self, passwords):
    self.passwords = passwords

  def as_xml(self):
    print('<?xml version="1.0" encoding="UTF-8"?>')
    print('<pwlist>')
    for password in self.passwords:
      password.as_keepass_xml()
    print('</pwlist>')

class KeePassX:
  def __init__(self, passwords):
    self.passwords = passwords
    self.groups = []

  def as_xml(self):
    print('<!DOCTYPE KEEPASSX_DATABASE>')
    print('<database>')
    for password in self.passwords:
      if password.group not in self.groups:
        self.groups.append(password.group)

    self.groups.sort()
    for group in self.groups:
      print("  <group>")
      print("    <title>%s</title>" % (group))
      print("    <icon>1</icon>")
      for password in self.passwords:
        if password.group == group:
          password.as_keepassx_xmldb()
      print("  </group>")
    print('</database>')


class FPMHandler(xml.sax.handler.ContentHandler):
  """
  Parses an FPM2 exported password file.
  Generates a list of passwords.
  """

  def __init__(self):
    xml.sax.handler.ContentHandler.__init__(self)
    self.passwords = []
    self.content = ''
    self.new_pass = Password()

  def startElement(self, name, attributes):
    """
    Return the element
    """
    pass

  def characters(self, chars):
    """
    Return the CDATA
    """
    self.content = self.content + chars.encode('utf8')

  def endElement(self, name):
    """
    Ends the element. If PasswordItem, create a password and shove it into the list.
    """

    # Strip beginning/ending whitespace and escape content
    self.content = xml.sax.saxutils.escape(self.content.strip())
    if name == 'title':
      self.new_pass.title = self.content
    elif name == 'user':
      self.new_pass.username = self.content
    elif name == 'url':
      self.new_pass.url = self.content
    elif name == 'password':
      self.new_pass.password = self.content
    elif name == 'notes':
      self.new_pass.notes = self.content
    elif name == 'category':
      self.new_pass.group = self.content
    elif name == 'PasswordItem':
      self.passwords.append(self.new_pass)
      self.new_pass = Password()

    # Clean up self.content
    self.content = ''

class Password:
  """
  Represents a password
  """

  def __init__(self):
    self.title = None
    self.group = None
    self.username = None
    self.url = None
    self.password = None
    self.notes = None

  def as_keepass_xml(self):
    print("<pwentry>")
    print("  <group>%s</group>" % (self.group))
    print("  <title>%s</title>" % (self.title))
    print("  <username>%s</username>" % (self.username))
    print("  <url>%s</url>" % (self.url))
    print("  <password>%s</password>" % (self.password))
    print("  <notes>%s</notes>" % (self.notes))
    print("</pwentry>")

  def as_keepassx_xmldb(self):
    print("    <entry>")
    print("      <title>%s</title>" % (self.title))
    print("      <username>%s</username>" % (self.username))
    print("      <password>%s</password>" % (self.password))
    print("      <url>%s</url>" % (self.url))
    print("      <comment>%s</comment>" % (self.notes))
    print("      <icon>1</icon>")
    print("      <expire>Never</expire>")
    print("    </entry>")

def error_nofile():
  """
  exit with message
  """
  print "need fpm filename as argument"
  sys.exit(1);

def main():
  """
  Parse the file passed as argument
  """

  if len(sys.argv) > 1:
    if os.path.isfile(sys.argv[1]):
      fname = sys.argv[1]
    else:
      error_nofile()
  else:
    error_nofile()
																  
  locator = xml.sax.xmlreader.Locator()
  parser = xml.sax.make_parser()
  handler = FPMHandler()
  handler.setDocumentLocator(locator)
  parser.setContentHandler(handler)
  parser.parse(sys.argv[1])
  
  keepass = KeePassX(handler.passwords)
  keepass.as_xml()

if __name__ == '__main__':
  main()
