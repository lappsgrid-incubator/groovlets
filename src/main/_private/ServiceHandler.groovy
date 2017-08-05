package src.main._private

//import groovy.util.logging.Slf4j
@GrabConfig(systemClassLoader=true)
@Grab("net.servicegrid:jp.go.nict.langrid.client:1.0.5")
import jp.go.nict.langrid.client.RequestAttributes
@Grab("net.servicegrid:jp.go.nict.langrid.client.soap:1.0.5")
import jp.go.nict.langrid.client.soap.SoapClientFactory
@Grab('org.langrid:jp.go.nict.langrid.service.management_1_2:1.0.10')
import jp.go.nict.langrid.service_1_2.foundation.MatchingCondition
import jp.go.nict.langrid.service_1_2.foundation.Order
import jp.go.nict.langrid.service_1_2.foundation.servicemanagement.ServiceEntrySearchResult
import jp.go.nict.langrid.service_1_2.foundation.servicemanagement.ServiceManagementService

import javax.servlet.http.HttpServletResponse

//String method = request.method
//String url = 'http://vassar.lappsgrid.org'
//
//String username = System.getenv('SERVICE_MANAGER_USERNAME')
//String password = System.getenv('SERVICE_MANAGER_PASSWORD')
//
//if (!username || !password) {
//    response.status = HttpServletResponse.SC_INTERNAL_SERVER_ERROR
//    out.println "This service has not been properly configured."
//    return
//}
//
//if (method != 'GET') {
//    response.status = HttpServletResponse.SC_METHOD_NOT_ALLOWED
//    response.addHeader('Allow', 'GET')
//    return
//}

//@Slf4j("logger")
class ServiceHandler {

    String url
    String username
    String password
    String node

    def params
    def headers
    def out
    def response
    def html

    Map searchTerms

    public ServiceHandler(def parent) {
//        logger.info("Initializing handler")
        params = parent.params
        headers = parent.headers
        out = parent.out
        response = parent.response
        html = parent.html
        searchTerms = [
                id:'serviceId',
                name: 'serviceName',
                desc: 'serviceDescription',
                type: 'serviceType',
                domain: 'serviceTypeDomain'
        ]
    }

    void handle() { //def params, def headers, def out, def response, def html) {

//        logger.debug("processing parameters")
        def conditions = new MatchingCondition[params.size()]
        int i = 0
        params.each { name,value ->
            name = searchTerms[name] ?: name
            conditions[i] = new MatchingCondition(name, value, "PARTIAL")
            ++i
        }

//        logger.debug("creating soap client")
        def order = [] as Order[]
        SoapClientFactory f = new SoapClientFactory();
        ServiceManagementService s = f.create(
                ServiceManagementService.class,
                new URL("$url/services/ServiceManagement")
        );
        RequestAttributes attr = (RequestAttributes)s;
        attr.setUserId(username);
        attr.setPassword(password);

        // The data that will be rendered as JSON or passed to the html template.
        Map result = [:]
        result.url = url
        result.totalCount = 0
        result.elements = []

        // The ServiceManager only allows us to fetch metadata for 100 services at a
        // time. So we have to be prepared to page through the entire list if more than
        // 100.
//        logger.debug("paging data")
        int PAGE_SIZE = 100
        int count = 0
        ServiceEntrySearchResult more = s.searchServices(count, PAGE_SIZE, conditions, order, "ALL");
        while (more.elements.length > 0) {
            result.elements.addAll more.elements
            count += more.elements.length
            more = s.searchServices(count, PAGE_SIZE, conditions, order, "ALL")
        }
        result.totalCount = count
        if (headers.Accept == '*/*' || headers.Accept?.contains('application/json')) {
//            logger.debug("returning application/json")
            response.status = 200
            response.contentType = 'application/json'
            out.println new groovy.json.JsonBuilder(result).toPrettyString()
        }
        else if (headers.Accept?.contains('text/html')) {
//            logger.debug("returning text/html")
            File template = new File('src/main/templates/services.gsp')
            result.node = node
//            result.heading = heading //"LAPPS Services on the Vassar node"
            Binding binding = new Binding()
            binding.html = html
            binding.data = result
            def shell = new GroovyShell(binding)
            def script = shell.parse(template)
            script.run()
        }
        else {
//            logger.warn("Invalid accept header: {}", headers.Accept)
            response.status = 406
            response.addHeader('Accept', 'application/json, text/html')
            out.println "Please request application/json or text/html"
            out.println "Sent Accept: ${headers.Accept}"
        }

    }
}