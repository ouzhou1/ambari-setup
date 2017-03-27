#!/usr/bin/env python
"""
Send request to Ambari Server
Request method types: GET, POST, PUT, DELETE
"""
import pycurl
import yaml
import os
import argparse

from StringIO import StringIO


class Ambari(object):

    def __init__(self, amb_yml_conf = None):
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
        return ambari api baseurl
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

    def put(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0, *args):
        """
        Put request method function
        post_field
        """

        string_buffer = StringIO()
        c = pycurl.Curl()
        try:
            http_header = ['%s: %s' % (key, value) for key, value in self.amb_api_headers().iteritems()]
            post_fields = post_fields
            baseurl = baseurl or self.amb_api_baseurl()
            request_url = "%s/%s" % (baseurl, url_postfix)

            c.setopt(pycurl.URL, request_url)
            c.setopt(pycurl.HTTPAUTH, pycurl.HTTPAUTH_BASIC)
            c.setopt(pycurl.USERPWD, "%(username)s:%(password)s" % self.amb_api_auth())
            c.setopt(pycurl.HTTPHEADER, http_header)
            c.setopt(pycurl.CUSTOMREQUEST, "PUT")
            c.setopt(pycurl.POSTFIELDS, post_fields)
            c.setopt(pycurl.WRITEFUNCTION, string_buffer.write)
            c.setopt(pycurl.CONNECTTIMEOUT, 30)
            c.setopt(pycurl.VERBOSE, detail)

            print """Put request to: %s\nWith post fields: %s""" % (request_url, post_fields)

            c.perform()
            status = c.getinfo(c.HTTP_CODE)
            string_buffer_value = string_buffer.getvalue()
            string_buffer.close()
            c.close()

            print status
            print string_buffer_value

        except Exception as E:
            print "Failed to execute put method to URL: %s\nDue to: %s\nWith post fields: %s" % (request_url, E,
                                                                                                 post_fields)

    def upload_file(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0, *args):
        """
        Put request method function
        post_field
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
            c.setopt(pycurl.UPLOAD, 1)
            c.setopt(pycurl.VERBOSE, detail)

            with open(upload_file, 'rb') as upload_fd:
                c.setopt(pycurl.READFUNCTION, upload_fd.read)
                file_size = os.path.getsize(upload_file)
                c.setopt(pycurl.INFILESIZE, file_size)
                print "Put request to: %s\nWith post upload file: %s" % \
                      (request_url, upload_file)
                c.perform()

            status = c.getinfo(c.HTTP_CODE)
            string_buffer_value = string_buffer.getvalue()
            string_buffer.close()
            c.close()

            print status
            print string_buffer_value

        except Exception as E:
            print "Failed to execute put method to URL: %s\nDue to: %s\n" % (request_url, E)

    def delete(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0, *args):
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
            status = c.getinfo(c.HTTP_CODE)
            string_buffer_value = string_buffer.getvalue()
            string_buffer.close()
            c.close()

            print status
            print string_buffer_value

        except Exception as E:
            print "Failed to execute Delete method to URL: %s\nDue to: %s\n" % (request_url, E)

    def get(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0, *args):
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
            c.setopt(pycurl.CUSTOMREQUEST, "GET")
            c.setopt(pycurl.CONNECTTIMEOUT, 30)
            c.setopt(pycurl.VERBOSE, detail)

            if post_fields:
                c.setopt(pycurl.POSTFIELDS, post_fields)

            c.perform()

            status = c.getinfo(c.HTTP_CODE)
            string_buffer_value = string_buffer.getvalue()
            string_buffer.close()
            c.close()

            print status
            print string_buffer_value

        except Exception as E:
            print "Failed to execute Get method to URL: %s\nDue to: %s\n" % (request_url, E)

    def ambari_initial(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0, *args):

        ambari_cluster_bpt_conf_file = self.amb_bpt_cls_conf()
        ambari_hosts_map_file = self.amb_bpt_host_mp()

        ambari_cluster_postfix_url = self.amb_cls_postfix_url()
        ambari_blueprints_postfix_url = self.amb_bpt_postfix_url()

        ambari_cluster_hdp_repo_postfix_url = self.amb_hdp_repo_postfix_url()
        ambari_cluster_hdp_util_repo_postfix_url = self.amb_hdp_utils_repo_postfix_url()

        ambari_cluster_new_hdp_repo_info = self.amb_hdp_new_repo_info()
        ambari_cluster_hdp_util_repo_postfix_info = self.amb_hdp_utils_new_repo_info()

        self.delete(ambari_cluster_postfix_url, post_fields, upload_file, baseurl, detail)
        self.delete(ambari_blueprints_postfix_url, post_fields, upload_file, baseurl, detail)
        self.put(ambari_cluster_hdp_repo_postfix_url, ambari_cluster_new_hdp_repo_info, upload_file, baseurl, detail)
        self.put(ambari_cluster_hdp_util_repo_postfix_url, ambari_cluster_hdp_util_repo_postfix_info, upload_file,
                 baseurl, detail)
        self.upload_file(ambari_blueprints_postfix_url, post_fields, ambari_cluster_bpt_conf_file, baseurl, detail)
        self.upload_file(ambari_cluster_postfix_url, post_fields, ambari_hosts_map_file, baseurl, detail)

    def ambari_scale(self, url_postfix=None, post_fields=None, upload_file=None, baseurl=None, detail=0,
                     scale_hosts=None, *args):
        """
        TODO:
        """
        ambari_blueprints_scale_conf = self.amb_bpt_scale_conf()
        if scale_hosts:
            for scale_host in scale_hosts:
                post_fields = "%s/%s" % (post_fields, scale_host)
                self.upload_file(url_postfix, post_fields, ambari_blueprints_scale_conf, baseurl, detail)
        else:
            raise Exception("No scale hosts given!!!")


def main():
    """
    #todo:
    """
    ambari = Ambari()

    parser = argparse.ArgumentParser(description="Ambari Cluster Curl API")
    parser.add_argument("-a", action="store", dest="url_postfix", help='baseurl postfix or api url')
    parser.add_argument("-p", action="store", dest="post_fields", help="post fields")
    parser.add_argument("-u", action="store", dest="upload_file", help="upload file name")
    parser.add_argument("-b", action="store", dest="baseurl", help="ambari server api base url")
    parser.add_argument("-v", action="store_true", dest="detail", default=True, help="verbosity turned on")
    parser.add_argument("-f", action="store", dest="request_method", help="request method")
    parser.add_argument("-s", nargs='+', action="store", dest="scale_hosts", help="scale extend hosts")

    print parser.parse_args()
    args = parser.parse_args()

    if args.detail:
        detail = 1
    else:
        detail = 0

    request_method_dict = {
        'delete': ambari.delete,
        'upload_file': ambari.upload_file,
        'put': ambari.put,
        'get': ambari.get,
        'ambari_initial': ambari.ambari_initial,
        'ambari_scale': ambari.ambari_scale,
    }

    request_method = args.request_method

    if request_method in request_method_dict.keys():
        request_method_dict[request_method](args.url_postfix,
                                            args.post_fields,
                                            args.upload_file,
                                            args.baseurl,
                                            detail,
                                            args.scale_hosts)

if __name__ == '__main__':
    main()
