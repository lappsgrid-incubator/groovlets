html.html {
    head {
        title 'Serivce Metadata'
        link rel:'stylesheet', href:'/style/main.css'
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
