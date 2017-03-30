#!/usr/bin/env python
"""
Send request to Ambari Server
Request method types: GET, POST, PUT, DELETE
"""
import pycurl
import yaml
import json
import os
import argparse
from StringIO import StringIO
import time


class Ambari(object):

    SERVICES = []
    SITE_TYPE = []

    def __init__(self, amb_yml_conf=None):
        """
        TODO:
        """
        self.amb_yml_conf = amb_yml_conf or ".ambari-cluster.yaml"

    def amb_cluster(self):
        """
        return ambari cluster dict from yaml file
        """
        try:
            with open(self.amb_yml_conf, 'r') as yml_stream:
                amb_dict = yaml.load(yml_stream)
            return amb_dict
        except Exception as E:
            print "Failed to acquire local ambari-cluster info due to: %s" % E

    def amb_cluster_name(self):
        """
        return ambari cluster name
        """
        try:
            return self.amb_cluster()['ambari-cluster']['cluster_name']
        except Exception as E:
            print "Failed to acquire local ambari-cluster name due to: %s" % E

    def amb_cluster_detail(self):
        """
        return ambari cluster info dict filtered by ambari cluster name
        """
        try:
            return self.amb_cluster()['ambari-cluster']
        except Exception as E:
            print "Failed to acquire local ambari-cluster info due to: %s" % E

    def amb_api_baseurl(self):
        """
        return ambari api baseurl which is used for CSRF authentication
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['baseurl']
        except Exception as E:
            print "Failed to acquire local ambari-cluster api baseurl due to: %s" % E

    def amb_api_headers(self):
        """
        return ambari api headers for request
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['headers']
        except Exception as E:
            print "Failed to acquire local ambari-cluster api headers due to: %s" % E

    def amb_api_auth(self):
        """
        return api auth username password
        """
        amb_cluster_api_info = self.amb_cluster_detail()['ambari-api']
        try:
            amb_api_auth = {"username": amb_cluster_api_info['username'], "password": amb_cluster_api_info['password']}
            return amb_api_auth
        except Exception as E:
            print "Failed to acquire local ambari-cluster api auth username/password due to: %s" % E

    def amb_api_blueprints_name(self):
        """
        return ambari api blueprints
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['blueprints']
        except Exception as E:
            print "Failed to acquire local ambari-cluster blueprints due to: %s" % E

    def amb_bpt_cls_conf(self):
        """
        return ambari blueprints cluster configuration file name
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['blueprints_cluster_conf']
        except Exception as E:
            print "Failed to acquire local ambari-cluster blueprints cluster config file due to: %s" % E

    def amb_bpt_host_mp(self):
        """
        return ambari blueprints cluster host mapping file name
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['blueprints_host_map']
        except Exception as E:
            print "Failed to acquire local ambari-cluster blueprints host map file due to: %s" % E

    def amb_bpt_scale_conf(self):
        """
        return ambari blueprints cluster extend scale node config file
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['blueprints_scale_conf']
        except Exception as E:
            print "Failed to acquire local ambari-cluster blueprints scale extend file due to: %s" % E

    def amb_cls_postfix_url(self):
        """
        return ambari postfix url of cluster based on api base url
        eg: "clusters/ambari-cluster"
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['url_postfix_cluster']
        except Exception as E:
            print "Failed to acquire local ambari-cluster postfix url due to: %s" % E

    def amb_bpt_postfix_url(self):
        """
        return ambari postfix url of blueprints based on api base url
        eg: "blueprints/bpt"
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['url_postfix_blueprints']
        except Exception as E:
            print "Failed to acquire local ambari-cluster blueprints postfix url due to: %s" % E

    def amb_hdp_repo_postfix_url(self):
        """
        return ambari postfix url of hdp repo based on api base url
        eg: 'stacks/HDP/versions/2.5/operating_systems/ubuntu14/repositories/HDP-2.5'
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['url_postfix_HDP_repo']
        except Exception as E:
            print "Failed to acquire original ambari-cluster hdp repo postfix url due to: %s" % E

    def amb_hdp_utils_repo_postfix_url(self):
        """
        return ambari postfix url of hdp-utils repo based on api base url
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['url_postfix_HDP_UTILS_repo']
        except Exception as E:
            print "Failed to acquire original ambari-cluster hdp-utils repo postfix url due to: %s" % E

    def amb_hdp_new_repo_info(self):
        """
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['new_HDP_repo_info']
        except Exception as E:
            print "Failed to acquire local ambari-cluster new hdp repo info due to: %s" % E

    def amb_hdp_utils_new_repo_info(self):
        """
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['new_HDP_UTILS_repo_info']
        except Exception as E:
            print "Failed to acquire local ambari-cluster new hdp-utils repo info due to: %s" % E

    def amb_site_config_postfix_url(self):
        """
        """
        try:
            return self.amb_cluster_detail()['ambari-api']['site_config_postfix_url']
        except Exception as E:
            print "Failed to acquire local ambari-cluster site config postfix due to: %s" % E

    def put(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0, *args):
        """
        Put request method function
        only post post_field
        """

        string_buffer = StringIO()
        c = pycurl.Curl()
        try:
            http_header = ['%s: %s' % (key, value) for key, value in self.amb_api_headers().iteritems()]
            baseurl = baseurl or self.amb_api_baseurl()
            request_url = "%s/%s" % (baseurl, url_postfix)

            c.setopt(pycurl.URL, request_url)
            c.setopt(pycurl.HTTPAUTH, pycurl.HTTPAUTH_BASIC)
            c.setopt(pycurl.USERPWD, "%(username)s:%(password)s" % self.amb_api_auth())
            c.setopt(pycurl.HTTPHEADER, http_header)
            c.setopt(pycurl.CUSTOMREQUEST, "PUT")
            c.setopt(pycurl.WRITEFUNCTION, string_buffer.write)
            c.setopt(pycurl.CONNECTTIMEOUT, 30)
            c.setopt(pycurl.VERBOSE, detail)

            if post_fields:
                c.setopt(pycurl.POSTFIELDS, post_fields)
                print """Put request to: %s\nWith put fields: %s""" % (request_url, post_fields)
                c.perform()
                return_content = string_buffer.getvalue()
                return_code = c.getinfo(c.RESPONSE_CODE)
                string_buffer.close()
                c.close()
                return {"return_code": return_code, "return_contentn": return_content}

            elif upload_file:
                c.setopt(pycurl.UPLOAD, 1)
                with open(upload_file, 'rb') as upload_fd:
                    c.setopt(pycurl.READFUNCTION, upload_fd.read)
                    file_size = os.path.getsize(upload_file)
                    c.setopt(pycurl.INFILESIZE, file_size)
                    print "Put request to: %s\nWith put upload file: %s" % \
                          (request_url, upload_file)
                    c.perform()
                    return_content = string_buffer.getvalue()
                    return_code = c.getinfo(c.RESPONSE_CODE)
                    string_buffer.close()
                    c.close()
                    return {"return_code": return_code, "return_contentn": return_content}

        except Exception as E:
            print "Failed to execute put method to URL: %s\nDue to: %s" % (request_url, E)

    def post(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0, *args):
        """
        Put request method function
        only upload file
        """

        string_buffer = StringIO()
        c = pycurl.Curl()
        try:
            http_header = ['%s: %s' % (key, value) for key, value in self.amb_api_headers().iteritems()]
            baseurl = baseurl or self.amb_api_baseurl()
            request_url = "%s/%s" % (baseurl, url_postfix)

            c.setopt(pycurl.URL, request_url)
            c.setopt(pycurl.HTTPAUTH, pycurl.HTTPAUTH_BASIC)
            c.setopt(pycurl.USERPWD, "%(username)s:%(password)s" % self.amb_api_auth())
            c.setopt(pycurl.HTTPHEADER, http_header)
            c.setopt(pycurl.CUSTOMREQUEST, "POST")
            c.setopt(pycurl.WRITEFUNCTION, string_buffer.write)
            c.setopt(pycurl.CONNECTTIMEOUT, 30)
            c.setopt(pycurl.VERBOSE, detail)

            if post_fields:
                c.setopt(pycurl.POSTFIELDS, post_fields)
                print """Post request to: %s\nWith post fields: %s""" % (request_url, post_fields)
                c.perform()
                return_content = string_buffer.getvalue()
                return_code = c.getinfo(c.RESPONSE_CODE)
                string_buffer.close()
                c.close()
                return {"return_code": return_code, "return_contentn": return_content}

            elif upload_file:
                c.setopt(pycurl.UPLOAD, 1)
                with open(upload_file, 'rb') as upload_fd:
                    c.setopt(pycurl.READFUNCTION, upload_fd.read)
                    file_size = os.path.getsize(upload_file)
                    c.setopt(pycurl.INFILESIZE, file_size)
                    print "Post request to: %s\nWith post upload file: %s" % \
                          (request_url, upload_file)
                    c.perform()
                    return_content = string_buffer.getvalue()
                    return_code = c.getinfo(c.RESPONSE_CODE)
                    string_buffer.close()
                    c.close()
                    return {"return_code": return_code, "return_contentn": return_content}

        except Exception as E:
            print "Failed to execute put method to URL: %s\nDue to: %s\n" % (request_url, E)

    def delete(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0, *args):
        """
        TODO:
        """
        string_buffer = StringIO()
        c = pycurl.Curl()
        try:
            http_header = ['%s: %s' % (key, value) for key, value in self.amb_api_headers().iteritems()]
            baseurl = baseurl or self.amb_api_baseurl()
            request_url = "%s/%s" % (baseurl, url_postfix)

            c.setopt(pycurl.URL, request_url)
            c.setopt(pycurl.HTTPAUTH, pycurl.HTTPAUTH_BASIC)
            c.setopt(pycurl.USERPWD, "%(username)s:%(password)s" % self.amb_api_auth())
            c.setopt(pycurl.HTTPHEADER, http_header)
            c.setopt(pycurl.CUSTOMREQUEST, "DELETE")
            c.setopt(pycurl.CONNECTTIMEOUT, 30)
            c.setopt(pycurl.VERBOSE, detail)

            if post_fields:
                c.setopt(pycurl.POSTFIELDS, post_fields)

            c.perform()
            return_code = c.getinfo(c.RESPONSE_CODE)
            return_content = string_buffer.getvalue()
            c.close()
            string_buffer.close()

            return {"return_code": return_code, "return_content": return_content}

        except Exception as E:
            print "Failed to execute Delete method to URL: %s\nDue to: %s\n" % (request_url, E)

    def get(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0, *args):
        """
        TODO:
        """
        string_buffer = StringIO()
        c = pycurl.Curl()
        try:
            http_header = ['%s: %s' % (key, value) for key, value in self.amb_api_headers().iteritems()]
            baseurl = baseurl or self.amb_api_baseurl()
            request_url = "%s/%s" % (baseurl, url_postfix)

            c.setopt(pycurl.URL, request_url)
            c.setopt(pycurl.HTTPAUTH, pycurl.HTTPAUTH_BASIC)
            c.setopt(pycurl.USERPWD, "%(username)s:%(password)s" % self.amb_api_auth())
            c.setopt(pycurl.HTTPHEADER, http_header)
            c.setopt(pycurl.WRITEFUNCTION, string_buffer.write)
            c.setopt(pycurl.CUSTOMREQUEST, "GET")
            c.setopt(pycurl.CONNECTTIMEOUT, 30)
            c.setopt(pycurl.VERBOSE, detail)

            if post_fields:
                c.setopt(pycurl.POSTFIELDS, post_fields)

            c.perform()
            return_content = string_buffer.getvalue()
            string_buffer.close()
            return_code = c.getinfo(c.RESPONSE_CODE)
            c.close()
            string_buffer.close()

            return {"return_code": return_code, "return_content": return_content}

        except Exception as E:
            print "Failed to execute Get method to URL: %s\nDue to: %s\n" % (request_url, E)

    def hdp_reset(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0, *args):
        """
        TODO:
        """
        ambari_cluster_bpt_conf_file = self.amb_bpt_cls_conf()
        ambari_hosts_map_file = self.amb_bpt_host_mp()

        ambari_cluster_postfix_url = self.amb_cls_postfix_url()
        ambari_blueprints_postfix_url = self.amb_bpt_postfix_url()

        ambari_cluster_hdp_repo_postfix_url = self.amb_hdp_repo_postfix_url()
        ambari_cluster_hdp_util_repo_postfix_url = self.amb_hdp_utils_repo_postfix_url()

        ambari_cluster_new_hdp_repo_info = self.amb_hdp_new_repo_info()
        ambari_cluster_hdp_util_repo_postfix_info = self.amb_hdp_utils_new_repo_info()

        # delete existed cluster and blueprint
        self.delete(url_postfix=ambari_cluster_postfix_url, detail=detail)
        self.delete(url_postfix=ambari_blueprints_postfix_url, detail=detail)
        # set ambari HDP repo info
        self.put(url_postfix=ambari_cluster_hdp_repo_postfix_url, post_fields=ambari_cluster_new_hdp_repo_info,
                 detail=detail)
        self.put(url_postfix=ambari_cluster_hdp_util_repo_postfix_url,
                 post_fields=ambari_cluster_hdp_util_repo_postfix_info, detail=detail)
        # upload blueprint and hostmaping file to trigger ambari cluster setup
        self.post(url_postfix=ambari_blueprints_postfix_url, upload_file=ambari_cluster_bpt_conf_file,
                 detail=detail)
        self.post(url_postfix=ambari_cluster_postfix_url, upload_file=ambari_hosts_map_file, detail=detail)

    def hdp_setup(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0, *args):
        """
        TODO:
        """
        ambari_cluster_bpt_conf_file = self.amb_bpt_cls_conf()
        ambari_hosts_map_file = self.amb_bpt_host_mp()

        ambari_cluster_postfix_url = self.amb_cls_postfix_url()
        ambari_blueprints_postfix_url = self.amb_bpt_postfix_url()

        ambari_cluster_hdp_repo_postfix_url = self.amb_hdp_repo_postfix_url()
        ambari_cluster_hdp_util_repo_postfix_url = self.amb_hdp_utils_repo_postfix_url()

        ambari_cluster_new_hdp_repo_info = self.amb_hdp_new_repo_info()
        ambari_cluster_hdp_util_repo_postfix_info = self.amb_hdp_utils_new_repo_info()

        return_code = self.get(ambari_cluster_postfix_url, post_fields, upload_file, baseurl, detail,
                               *args)["return_code"]

        # only trigger setup when no cluster existed, so 403 is returned
        if return_code == 404:
            # set ambari HDP repo info
            self.put(url_postfix=ambari_cluster_hdp_repo_postfix_url, post_fields=ambari_cluster_new_hdp_repo_info,
                     detail=detail)
            self.put(url_postfix=ambari_cluster_hdp_util_repo_postfix_url,
                     post_fields=ambari_cluster_hdp_util_repo_postfix_info, detail=detail)
            # upload blueprint and hostmaping file to trigger ambari cluster setup
            self.post(url_postfix=ambari_blueprints_postfix_url, upload_file=ambari_cluster_bpt_conf_file,
                     detail=detail)
            self.post(url_postfix=ambari_cluster_postfix_url, upload_file=ambari_hosts_map_file, detail=detail)

    def hdp_scale(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0, scale_hosts=None,
                  *args):
        """
        TODO:
        """
        ambari_blueprints_scale_conf = self.amb_bpt_scale_conf()
        ambari_cluster_postfix_url = self.amb_cls_postfix_url()

        hosts_url_postfix = url_postfix or "%s/%s" % (ambari_cluster_postfix_url, "hosts")

        if scale_hosts:
            for scale_host in scale_hosts:
                url_postfix = "%s/%s" % (hosts_url_postfix, scale_host)
                self.post(url_postfix=url_postfix, upload_file=ambari_blueprints_scale_conf, detail=detail)
        else:
            raise Exception("No scale hosts given!!!")

    def hdp_property_config(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0,
                            scale_hosts=None, site_type=None, keys_and_new_values=None, *args):
        """
        For now, only change one property attribute.
        TODO: provided a change list
        """
        ambari_cluster_desire_config_format = '{ "Clusters": { "desired_config": {"type": "%s", "tag":"%s", ' \
                                              '"properties" : {}}}}'

        if site_type and keys_and_new_values:

            new_site_type_tag = "version_%s" % str(int(time.time()))

            ambari_cluster_postfix_url = self.amb_cls_postfix_url()
            ambari_cluster_site_config_postfix_url = self.amb_site_config_postfix_url()
            ambari_cluster_site_config_url_format = "%s/%s" % (ambari_cluster_postfix_url,
                                                               ambari_cluster_site_config_postfix_url)

            site_desired_config_tag_url = "%s?fields=Clusters/desired_configs/%s" % (ambari_cluster_postfix_url,
                                                                                     site_type)

            site_desired_config = json.loads(self.get(url_postfix=site_desired_config_tag_url, detail=detail)
                                             ["return_content"])

            site_type_latest_tag = site_desired_config['Clusters']['desired_configs']['%s' % site_type]['tag']

            ambari_cluster_site_config_url = ambari_cluster_site_config_url_format % (site_type, site_type_latest_tag)

            url_postfix = url_postfix or ambari_cluster_site_config_url

            cluster_site_config_json = json.loads(self.get(url_postfix=url_postfix, detail=detail)["return_content"])
            cluster_site_config_properties = cluster_site_config_json['items'][0]['properties']

            for key_new_value in keys_and_new_values:
                key, new_value = key_new_value.split(":", 1)
                cluster_site_config_properties[key] = new_value

            ambari_cluster_site_desire_config = ambari_cluster_desire_config_format % (site_type, new_site_type_tag)
            ambari_cluster_site_desire_config_json = json.loads(ambari_cluster_site_desire_config)
            ambari_cluster_site_desire_config_json['Clusters']['desired_config']['properties'] = \
                cluster_site_config_properties

            cluster_site_config_json_file = "cluster_site_config_json_%s.json" % new_site_type_tag

            with open(cluster_site_config_json_file, "w") as site_config_json:
                json.dump(ambari_cluster_site_desire_config_json, site_config_json)

            self.put(url_postfix=ambari_cluster_postfix_url, upload_file=cluster_site_config_json_file,
                             detail=detail)

        else:
            raise TypeError("check key/new_value site-type...etc, exit!")

    def hdp_service_stop(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0,
                         scale_hosts=None, site_type=None, keys_and_new_values=None, service_name=None, *args):
        """
        For example: YARN service, post_fields should be like
        '{"RequestInfo": {"context": "Stop YARN"}, "ServiceInfo": {"state": "INSTALLED"}}'
        """
        if service_name:

            ambari_cluster_postfix_url = self.amb_cls_postfix_url()
            ambari_cluster_service_name = "%s/services/%s" % (ambari_cluster_postfix_url, service_name)

            url_postfix = url_postfix or ambari_cluster_service_name

            self.put(url_postfix=url_postfix, post_fields=post_fields, detail=detail)
        else:
            raise Exception("No service_name provided!!!")

    def hdp_service_start(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0,
                          scale_hosts=None, site_type=None, keys_and_new_values=None, service_name=None, *args):
        """
        For example: YARN service, post_fields should be like
        '{"RequestInfo": {"context": "Start YARN"}, "ServiceInfo": {"state": "STARTED"}}'
        """
        if service_name:

            ambari_cluster_postfix_url = self.amb_cls_postfix_url()
            ambari_cluster_service_name = "%s/services/%s" % (ambari_cluster_postfix_url, service_name)

            url_postfix = url_postfix or ambari_cluster_service_name

            self.put(url_postfix=url_postfix, post_fields=post_fields, detail=detail)
        else:
            raise Exception("No service_name provided!!!")


def main():
    """
    TODO:
    """
    ambari = Ambari()

    parser = argparse.ArgumentParser(description="Ambari Cluster Curl API")
    parser.add_argument("-a", action="store", dest="url_postfix", help='baseurl postfix or api url')
    parser.add_argument("-d", action="store", dest="post_fields", help="post fields")
    parser.add_argument("-u", action="store", dest="upload_file", help="upload file name")
    parser.add_argument("-b", action="store", dest="baseurl", help="ambari server api base url")
    parser.add_argument("-v", action="store_true", dest="detail", default=False, help="verbosity turned on")
    parser.add_argument("-f", action="store", dest="request_method", help="request method")
    parser.add_argument("-e", nargs='+', action="store", dest="scale_hosts", help="scale extend hosts")
    parser.add_argument("-t", action="store", dest="site_type", help="config set site type")
    parser.add_argument("-c", nargs='+', action="store", dest="keys_and_new_values", help="ambari site_type properties key")
    parser.add_argument("-s", action="store", dest="service_name", help="ambari service name")

    print parser.parse_args()
    args = parser.parse_args()

    if args.detail:
        detail = 1
    else:
        detail = 0

    request_method_dict = {
        'delete': ambari.delete,
        'post': ambari.post,
        'put': ambari.put,
        'get': ambari.get,
        'hdp_setup': ambari.hdp_setup,
        'hdp_scale': ambari.hdp_scale,
        'hdp_reset': ambari.hdp_reset,
        'hdp_property_config': ambari.hdp_property_config,
        'hdp_service_start': ambari.hdp_service_start,
        'hdp_service_stop': ambari.hdp_service_stop
    }

    request_method = args.request_method

    if request_method in request_method_dict.keys():
        request_method_dict[request_method](args.url_postfix,
                                            args.post_fields,
                                            args.upload_file,
                                            args.baseurl,
                                            detail,
                                            args.scale_hosts,
                                            args.site_type,
                                            args.keys_and_new_values,
                                            args.service_name)


if __name__ == '__main__':
    main()
