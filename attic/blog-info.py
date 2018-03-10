#!/usr/bin/env python3
#
# blog-info.py
# Counts the posts in my jekyll blog and gets the top tags
#
# Brandon Amos
# 2013.08.10
# Updated by Rob Harrigan
# 2018.03.09

import operator
import sys
import re

import requests
from bs4 import BeautifulSoup
import html.parser

h = html.parser.HTMLParser()


def getContent(url):
    headers = {'User-Agent': 'Mozilla/5.0'}
    page = requests.get(url)
    html = page.text
    if not html:
        sys.exit(42)
    return h.unescape(html)


def numPostsFromArchives(baseURL):
    headers = {'User-Agent': 'Mozilla/5.0'}
    page = requests.get(baseURL)
    soup = BeautifulSoup(page.text, 'html5lib')
    mainCol = soup.findAll('article')
    nArticles = len(mainCol)
    idx = 2
    while True:
        pageURL = "{}/page{}/".format(baseURL, idx)
        page = requests.get(pageURL)
        if page.status_code != requests.codes.ok:
            break
        soup = BeautifulSoup(page.text, 'html5lib')
        mainCol = soup.findAll('article')
        nArticles += len(mainCol)
        idx += 1
    return nArticles


def parseTags(tagContent):
    soup = BeautifulSoup(tagContent, 'html5lib')
    mainCol = soup.find('div', attrs={'class': 'archive'})
    headers = mainCol.find_all('h2')
    tags = {}
    for header in headers:
        if 'archive__subtitle' in dict(header.attrs)["class"]:
            curr_tag = header.contents[0]
        elif 'archive__item-title' in dict(header.attrs)["class"]:
            tags[curr_tag] = tags.get(curr_tag, 0) + 1

    sortedTags = sorted(tags.items(), key=operator.itemgetter(1), reverse=True)
    return [x[0] for x in sortedTags]


if __name__=='__main__':
    print(
      "{} posts across the following tags, listed by highest frequency.".format(
        numPostsFromArchives('https://unsupervisedpandas.com/')
      )
    )

    tagContent = getContent('https://unsupervisedpandas.com/tags/')
    print(", ".join(parseTags(tagContent)))
