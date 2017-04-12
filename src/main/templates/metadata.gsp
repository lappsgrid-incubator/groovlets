html.html {
    head {
        title 'Serivce Metadata'
        link rel:'stylesheet', href:'/style/main.css'
    }
    body {
        h1 "Service Metadata"
        table {
            simple_row 'Name', payload.name
            simple_row 'URL', url
            row 'Version', payload.version
            row 'Description', payload.description
            row 'Vendor', payload.vendor
            row 'Allow', payload.allow
            row 'License', payload.license
        }
        make_table('Requirements', payload.requires)
        make_table('Produces', payload.produces)
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

// Create a new table row, but don't create links for the value.
void simple_row(String name, String value) {
    if (value) {
        html.tr {
            td name
            td value
        }
    }
}

// Create a new table row.  If the value starts with http it will be included in
// an <a/> element.
void row(String name, String value) {
    if (value) {
        html.tr {
            td(class:'first-column', name)
            if (value.startsWith('http')) {
                td { a href:value, value }
            }
            else {
                td value
            }
        }
    }
}

// Creates a new table row where is the value is a list of String. The list values
// will be wrapped in <a/> tags if they start with http and then concatenated with
// <br/> tags.
void row(String name, List values) {
    def link = { url ->
        if (url.startsWith('http')) {
            return "<a href='$url'>$url</a>"
        }
        return url
    }

    if (values) {
        html.tr {
            td(class:'first-column', name)
            td { mkp.yieldUnescaped(values.collect{ link(it) }.join("<br/>")) }
        }
    }
}
