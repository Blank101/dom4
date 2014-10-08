/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is dom4 code.
 *
 * The Initial Developer of the Original Code is
 * Disruptive Innovations SAS
 * Portions created by the Initial Developer are Copyright (C) 2014
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Daniel Glazman <daniel.glazman@disruptive-innovations.com>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either of the GNU General Public License Version 2 or later (the "GPL"),
 * or the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

package dom4;

/*
 * https://dom.spec.whatwg.org/#interface-range
 */

class Range {

  public var startContainer(default, null): Node;
  public var startOffset(default, null): UInt;
  public var endContainer(default, null): Node;
  public var endOffset(default, null): UInt;
  public var collapsed(get, null): Bool;
      private function get_collapsed(): Bool
      {
        return (this.startContainer == this.endContainer
                && this.startOffset == this.endOffset);
      }

  public var commonAncestorContainer(get, null): Node;
      private function get_commonAncestorContainer(): Node
      {
        var startAncestors: Array<Node> = [];
        var node = this.startContainer;
        while (node != null) {
          startAncestors.insert(0, node);
          node = node.parentNode;
        }

        var endAncestors: Array<Node> = [];
        var node = this.endContainer;
        while (node != null) {
          endAncestors.insert(0, node);
          node = node.parentNode;
        }

        var index = Std.int( Math.min(startAncestors.length - 1, endAncestors.length - 1) ); // >= 0
        while (index >= 0) {
          if (startAncestors[index] == endAncestors[index])
            return startAncestors[index];
          index--;
        }

        throw (new DOMException("ShouldNeverHitError"));
      }

  /*
   * https://dom.spec.whatwg.org/#concept-range-bp-set
   */
  public function setStart(node: Node, offset: UInt): Void
  {
    if (node == null)
      throw (new DOMException("InvalidAccessError"));

    // the following differs from the spec on several counts:
    //   DocumentFragment are forbidden because I have no idea what means
    //     a range starting in a document and ending in a document fragment
    //   Comment and ProcessingInstruction are forbidden because starting
    //     or ending a range in the middle of such a node seems meaningless
    switch (node.nodeType) {
      case Node.DOCUMENT_TYPE_NODE
           | Node.DOCUMENT_FRAGMENT_NODE:
        throw (new DOMException("InvalidNodeTypeError"));

      case Node.TEXT_NODE:
        if (offset > cast(node, Text).data.length)
          throw (new DOMException("IndexSizeError"));

      case Node.COMMENT_NODE
           | Node.PROCESSING_INSTRUCTION_NODE:
        throw (new DOMException("InvalidNodeTypeError"));

      case Node.ELEMENT_NODE:        
        if (offset > cast(node, Element).childNodes.length)
          throw (new DOMException("IndexSizeError"));
    }

    this.startContainer = node;
    this.startOffset = offset;
  }

  /*
   * https://dom.spec.whatwg.org/#concept-range-bp-set
   */
  public function setEnd(node: Node, offset: UInt): Void
  {
    if (node == null)
      throw (new DOMException("InvalidAccessError"));

    // the following differs from the spec on several counts:
    //   DocumentFragment are forbidden because I have no idea what means
    //     a range starting in a document and ending in a document fragment
    //   Comment and ProcessingInstruction are forbidden because starting
    //     or ending a range in the middle of such a node seems meaningless
    switch (node.nodeType) {
      case Node.DOCUMENT_TYPE_NODE
           | Node.DOCUMENT_FRAGMENT_NODE:
        throw (new DOMException("InvalidNodeTypeError"));

      case Node.TEXT_NODE:
        if (offset > cast(node, Text).data.length)
          throw (new DOMException("IndexSizeError"));

      case Node.COMMENT_NODE
           | Node.PROCESSING_INSTRUCTION_NODE:
        throw (new DOMException("InvalidNodeTypeError"));

      case Node.ELEMENT_NODE:        
        if (offset > cast(node, Element).childNodes.length)
          throw (new DOMException("IndexSizeError"));
    }

    this.endContainer = node;
    this.endOffset = offset;
  }

  public function new(startContainer: Node,
                      startOffset: UInt,
                      endContainer: Node,
                      endOffset: UInt) {
    this.startContainer = startContainer;
    this.startOffset = startOffset;
    this.endContainer = endContainer;
    this.endOffset = endOffset;
  }
}
