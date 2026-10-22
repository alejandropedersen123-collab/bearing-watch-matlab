# Data provenance

Original source: Case Western Reserve University Bearing Data Center.

`download_data` obtains 97, 98, 99, 100, 108, 121 and 133 directly from `https://engineering.case.edu/sites/default/files/`. Exact channel selection uses the three-digit record identifier, e.g. `X099_DE_time`.

The raw files are not distributed under this repository's MIT license and are excluded from Git. Consult the source's terms before redistributing data. `manifest.csv` records the original URL, channel, role, size and SHA-256 for the locally evaluated files. The source tables label the selected fault recordings as 12k drive-end experiments; normal-record sample rates are not inferred from file length. The implemented detector works in samples and input acceleration units.

References:

- https://engineering.case.edu/bearingdatacenter/download-data-file
- https://engineering.case.edu/bearingdatacenter/normal-baseline-data
- https://engineering.case.edu/bearingdatacenter/12k-drive-end-bearing-fault-data
