#!perl

{
    package RSS;
    use Moose;
    use MooseX::DOM;

    dom_value 'version' => '@version';
    dom_nodes 'items' => (
        fetch => dom_fetchnodes(
            xpath => 'channel/item',
            filter => dom_to_class('RSS::Item')
        )
    );

    no Moose;
    no MooseX::DOM;

    package RSS::Item;
    use Moose;
    use MooseX::DOM;

    dom_value 'title';
    dom_value 'description';
    dom_value 'link';

    no Moose;
    no MooseX::DOM;

    sub BUILDARGS {
        my $class = shift;
        my $args  = {@_ == 1? (dom_root => $_[0]) : @_};
        return $args;
    }
}

package main;

my $rss = RSS->parse_string( do { local $/; <DATA> } );

print "parsed rss.\n",
    "  rss version = ", $rss->version, "\n";

print "  items:\n";
foreach my $item ($rss->items) {
    print "    + ", $item->link, "\n",
          "      ", $item->title, "\n";
}



__DATA__
<?xml version="1.0"?>
<rss version="2.0"
 xmlns:dc="http://purl.org/dc/elements/1.1/">
 <channel>
  <title>Example 2.0 Channel</title>
  <link>http://example.com/</link>
  <description>To lead by example</description>
  <language>en-us</language>
  <copyright>All content Public Domain, except comments which remains copyright the author</copyright> 
  <managingEditor>editor\@example.com</managingEditor> 
  <webMaster>webmaster\@example.com</webMaster>
  <docs>http://backend.userland.com/rss</docs>
  <category  domain="http://www.dmoz.org">Reference/Libraries/Library_and_Information_Science/Technical_Services/Cataloguing/Metadata/RDF/Applications/RSS/</category>
  <generator>The Superest Dooperest RSS Generator</generator>
  <lastBuildDate>Mon, 02 Sep 2002 03:19:17 GMT</lastBuildDate>
  <ttl>60</ttl>
  <item>
   <dc:subject>example subject</dc:subject>
   <title>News for September the Second</title>
   <link>http://example.com/2002/09/02</link>
   <description>other things happened today</description>
   <comments>http://example.com/2002/09/02/comments.html</comments>
   <author>joeuser\@example.com</author>
   <pubDate>Mon, 02 Sep 2002 03:19:00 GMT</pubDate>
   <guid isPermaLink="true">http://example.com/2002/09/02</guid>
   <enclosure url="http://example.com/podcast/20020902.mp3" type="audio/mpeg" length="65535"/>
  </item>

  <item>
   <title>News for September the First</title>
   <link>http://example.com/2002/09/01</link>
   <description>something happened today</description>
   <comments>http://example.com/2002/09/01/comments.html</comments>
   <author>joeuser\@example.com</author>
   <pubDate>Sun, 01 Sep 2002 12:01:00 GMT</pubDate>
   <guid isPermaLink="true">http://example.com/2002/09/02</guid>
   <enclosure url="http://example.com/podcast/20020901.mp3" type="audio/mpeg" length="4096"/>
   <enclosure url="http://example.com/podcast/20020903.mp3" type="audio/mpeg" length="4096"/>
   <enclosure url="http://example.com/podcast/20020904.mp3" type="audio/mpeg" length="4096"/>
  </item>

 </channel>
</rss>