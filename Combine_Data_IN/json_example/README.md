# Writing and Reading JSON with `jsonlite`

Using the [`jsonlite`](https://github.com/jeroen/jsonlite) library in R you can read, write, and manipulate JSON data.

This Gist contains an example (`write_json.R`) of writing a `list` containing ecological "data types" and arrays of column data types to a JSON file using `jsonlite::write_json`.

That JSON file nicely serializes a mapping of the key values (e.g.,
"FSH", "IHI") &mdash; the ecological data types &mdash; to the associated data &mdash; the column data types.

To use this serialization (a data structure written to file) an example is given (`read_json.R`) in which it is read into a data frame using `jsonlite::read_json`.
It can then be manipulated as normal.
**N.B.:** `jsonlite::read_json` can read either a file on disk or a file on a remote site if a URL is passed to it.

## Running

These examples can be run from the command line using `Rscript` with the following commands

```
$ Rscript write_json.R
Wrote file column_schemas.json to disk
```
followed by

```
$ Rscript read_json.R
[1] "The first column data type in the FSH data type is: text"
```

These can of course be run in RStudio as well by loading them in and then executing them in the IDE.
