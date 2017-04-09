html.html {
    head {
        title 'Serivce Metadata'
        style '''
                html {
                    margin: 10px 50px;
                }
                table {
                    width: 60%;
                    margin: 10px 20px;
                    border: 1px solid black;
                    -moz-border-radius: 5px;
                    -webkit-border-radius: 5px;
                    border-radius: 5px;
                }
                tr {
                    vertical-align: top;
                    padding: 0px;
                    margin: px;
                }
                tr:nth-child(odd) { background-color: #f5f5f5 }
                td {
                    padding: 3px 10px;
                }
                .name {
                    width:15%;
                    font-weight: bold;
                }
            '''

    }
    body {
        h1 "Service : ${payload.name}"
        table {
            row 'URL', url
            row 'Version', payload.version
            row 'Description', payload.description
            row 'Vendor', payload.vendor
            row 'Allow', payload.allow
            row 'License', payload.license
        }
        make_table('Requirements', payload.requires)
        make_table('Output', payload.produces)
    }
}

void make_table(String heading, Map map) {
    if (map) {
        html.h2 heading
        html.table {
            row 'Encoding', map.encoding
            row 'Language', map.language?.join(', ')
            row 'Formats', map.format
            row 'Annotations', map.annotations
        }
    }
}

void row(String name, String value) {
    if (value) {
        html.tr {
            td(class:'name', name)
            td value
        }
    }
}

void row(String name, List values) {
    if (values) {
        html.tr {
            td(class:'name', name)
            td { mkp.yieldUnescaped(values.join("<br/>")) }
        }
    }
}
