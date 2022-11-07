#!/bin/sh

echo '#!/bin/sh
exec aumix' > usr/local/bin/defaultaudiomixer
chmod 755 usr/local/bin/defaultaudiomixer
