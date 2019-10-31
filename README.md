This repository contains scripts and mapping files which will:

 * Download and extract metadata from the TEI files which form the catalogue of  
   [Medieval Manuscripts in Oxford Libraries](https://github.com/bodleian/medieval-mss), 
   including both manuscript records and work/person/place authorities.
 * Run the [x3ml](https://github.com/delving/x3ml) tool to generate RDF using 
   the CIDOC-CRM and FRBRoo ontologies, from that metadata.
 * Upload the RDF to GitHub. The format is RDF/XML and the output is chunked into
   multiple files to avoid memory issues and reduce processing times.
 * A Dockerfile to set up a virtual container in which to run the above, if required.

To run the process:

1. Download or clone this repository.
2. Go to the [bodleian-RDF](https://github.com/mapping-manuscript-migrations/bodleian-RDF)
   repository and click the **Fork** button.
3. Edit the settings.conf file, following the instructions within.
4. On UNIX systems such as Linux or MacOS, which have Java, Git client and cURL installed, 
   run `bash scripts/main.sh`
5. On Windows systems, on which Docker has been installed, run: 
   `docker build -t bodleian-mmm .` then `docker run bodleian-mmm`
6. To contribute the updated RDF files back to MMM's base repository, go to your fork
   and click the **New pull request** button.

The information extracted, and the mappings to ontologies, are tailored to the needs of 
the [Mapping Manuscript Migrations](http://mappingmanuscriptmigrations.org/) project. 
The scripts will not work, without modification, on other TEI manuscript descriptions, even 
ones using [the same schema](https://github.com/bodleian/consolidated-tei-schema). But they 
might be of interest to others building their own mappings.

More information can be found at https://mapping-manuscript-migrations.github.io/

