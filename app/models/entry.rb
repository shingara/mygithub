class Entry
  include Mongoid::Document
  field :content, :type => String

  def in_blather_node
    start = <<-EOF
      <message from="firehoser.superfeedr.com" to="sprsquish@superfeedr.com">
      <event xmlns="http://jabber.org/protocol/pubsub#event">
      <status xmlns="http://superfeedr.com/xmpp-pubsub-ext" feed="http://superfeedr.com/dummy.xml">
      <http code="200">957 bytes fetched in 0.228013s</http>
      <next_fetch>2009-11-05T16:34:12+00:00</next_fetch>
      </status>
      <items node="http://superfeedr.com/dummy.xml">
      <item xmlns="http://jabber.org/protocol/pubsub" chunks="1" chunk="1">

    EOF
    fin = <<-EOF
    </item>
       </items>
      </event>
      </message>
    EOF
    tmp  =  Nokogiri::XML(content).children.first.children[1].to_s
    Superfeedr::Entry.parse Blather::XMPPNode.import(Nokogiri::XML("#{start}\n#{tmp}\n#{fin}").root)
  end
end
