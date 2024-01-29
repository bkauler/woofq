#!/bin/sh

echo '#!/bin/sh' > usr/local/bin/defaultpdfviewer
echo 'exec evince "$@"' >> usr/local/bin/defaultpdfviewer
chmod 755 usr/local/bin/defaultpdfviewer

#fix, this is in rox pet pkg...
if [ -f root/Choices/MIME-types/application_pdf ];then
 sed -i -e 's%epdfview%defaultpdfviewer%' root/Choices/MIME-types/application_pdf
fi
