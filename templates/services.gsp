html.html {
    head {
        title data.title
        style '''
            html {
                margin: 10px 25px;
            }
            table {
                width: 90%;
                margin: 10px 20px;
                border: 1px solid black;
                border-radius: 5px;
            }
            tr {
                /* vertical-align: top; */
                padding: 0px;
                margin: px;
            }
            tr:nth-child(even) { background-color: #eee; }
            th {
                color: white;
                background-color: #333;
            }
            th, td {
                text-align: left;
                padding: 3px 10px;
            }
            p {
                margin: 10px 20px;
            }
'''
    }
    body {
        h1 data.heading
        p "Total Services Registered: ${data.totalCount}"
        table {
            thead {
                th 'ID'
                th 'Name'
                th 'Metadata'
            }
            tbody {
                data.elements.each { e->
                    String u = "http://api.lappsgrid.org/metadata?id=${e.serviceId}"
                    String handler = "window.open('$u', '_self')"
                    tr {
                        td e.serviceId
                        td e.serviceName
                        td {
                            button(onclick:"$handler", 'View')
                        }
                    }
                }
            }
        }
    }
}