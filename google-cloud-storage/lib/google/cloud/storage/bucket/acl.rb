# Copyright 2015 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


module Google
  module Cloud
    module Storage
      class Bucket
        ##
        # # Bucket Access Control List
        #
        # Represents a Bucket's Access Control List.
        #
        # @example
        #   require "google/cloud/storage"
        #
        #   storage = Google::Cloud::Storage.new
        #
        #   bucket = storage.bucket "my-bucket"
        #
        #   bucket.acl.readers.each { |reader| puts reader }
        #
        class Acl
          # @private
          RULES = { "authenticatedRead" => "authenticatedRead",
                    "auth" => "authenticatedRead",
                    "auth_read" => "authenticatedRead",
                    "authenticated" => "authenticatedRead",
                    "authenticated_read" => "authenticatedRead",
                    "private" => "private",
                    "projectPrivate" => "projectPrivate",
                    "proj_private" => "projectPrivate",
                    "project_private" => "projectPrivate",
                    "publicRead" => "publicRead",
                    "public" => "publicRead",
                    "public_read" => "publicRead",
                    "publicReadWrite" => "publicReadWrite",
                    "public_write" => "publicReadWrite" }

          ##
          # @private Initialized a new Acl object.
          # Must provide a valid Bucket object.
          def initialize bucket
            @bucket = bucket.name
            @service = bucket.service
            @owners  = nil
            @writers = nil
            @readers = nil
          end

          ##
          # Reloads all Access Control List data for the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.reload!
          #
          def reload!
            gapi = @service.list_bucket_acls @bucket
            acls = Array(gapi.items)
            @owners  = entities_from_acls acls, "OWNER"
            @writers = entities_from_acls acls, "WRITER"
            @readers = entities_from_acls acls, "READER"
          end
          alias_method :refresh!, :reload!

          ##
          # Lists the owners of the bucket.
          #
          # @return [Array<String>]
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.owners.each { |owner| puts owner }
          #
          def owners
            reload! if @owners.nil?
            @owners
          end

          ##
          # Lists the owners of the bucket.
          #
          # @return [Array<String>]
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.writers.each { |writer| puts writer }
          #
          def writers
            reload! if @writers.nil?
            @writers
          end

          ##
          # Lists the readers of the bucket.
          #
          # @return [Array<String>]
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.readers.each { |reader| puts reader }
          #
          def readers
            reload! if @readers.nil?
            @readers
          end

          ##
          # Grants owner permission to the bucket.
          #
          # @param [String] entity The entity holding the permission, in one of
          #   the following forms:
          #
          #   * user-userId
          #   * user-email
          #   * group-groupId
          #   * group-email
          #   * domain-domain
          #   * project-team-projectId
          #   * allUsers
          #   * allAuthenticatedUsers
          #
          # @example Grant access to a user by prepending `"user-"` to an email:
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   email = "heidi@example.net"
          #   bucket.acl.add_owner "user-#{email}"
          #
          # @example Grant access to a group by prepending `"group-"` to email:
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   email = "authors@example.net"
          #   bucket.acl.add_owner "group-#{email}"
          #
          def add_owner entity
            gapi = @service.insert_bucket_acl @bucket, entity, "OWNER"
            entity = gapi.entity
            @owners.push entity unless @owners.nil?
            entity
          end

          ##
          # Grants writer permission to the bucket.
          #
          # @param [String] entity The entity holding the permission, in one of
          #   the following forms:
          #
          #   * user-userId
          #   * user-email
          #   * group-groupId
          #   * group-email
          #   * domain-domain
          #   * project-team-projectId
          #   * allUsers
          #   * allAuthenticatedUsers
          #
          # @example Grant access to a user by prepending `"user-"` to an email:
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   email = "heidi@example.net"
          #   bucket.acl.add_writer "user-#{email}"
          #
          # @example Grant access to a group by prepending `"group-"` to email:
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   email = "authors@example.net"
          #   bucket.acl.add_writer "group-#{email}"
          #
          def add_writer entity
            gapi = @service.insert_bucket_acl @bucket, entity, "WRITER"
            entity = gapi.entity
            @writers.push entity unless @writers.nil?
            entity
          end

          ##
          # Grants reader permission to the bucket.
          #
          # @param [String] entity The entity holding the permission, in one of
          #   the following forms:
          #
          #   * user-userId
          #   * user-email
          #   * group-groupId
          #   * group-email
          #   * domain-domain
          #   * project-team-projectId
          #   * allUsers
          #   * allAuthenticatedUsers
          #
          # @example Grant access to a user by prepending `"user-"` to an email:
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   email = "heidi@example.net"
          #   bucket.acl.add_reader "user-#{email}"
          #
          # @example Grant access to a group by prepending `"group-"` to email:
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   email = "authors@example.net"
          #   bucket.acl.add_reader "group-#{email}"
          #
          def add_reader entity
            gapi = @service.insert_bucket_acl @bucket, entity, "READER"
            entity = gapi.entity
            @readers.push entity unless @readers.nil?
            entity
          end

          ##
          # Permanently deletes the entity from the bucket's access control
          # list.
          #
          # @param [String] entity The entity holding the permission, in one of
          #   the following forms:
          #
          #   * user-userId
          #   * user-email
          #   * group-groupId
          #   * group-email
          #   * domain-domain
          #   * project-team-projectId
          #   * allUsers
          #   * allAuthenticatedUsers
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   email = "heidi@example.net"
          #   bucket.acl.delete "user-#{email}"
          #
          def delete entity
            @service.delete_bucket_acl @bucket, entity
            @owners.delete entity  unless @owners.nil?
            @writers.delete entity unless @writers.nil?
            @readers.delete entity unless @readers.nil?
            true
          end

          # @private
          def self.predefined_rule_for rule_name
            RULES[rule_name.to_s]
          end

          # Predefined ACL helpers

          ##
          # Convenience method to apply the `authenticatedRead` predefined ACL
          # rule to the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.auth!
          #
          def auth!
            update_predefined_acl! "authenticatedRead"
          end
          alias_method :authenticatedRead!, :auth!
          alias_method :auth_read!, :auth!
          alias_method :authenticated!, :auth!
          alias_method :authenticated_read!, :auth!

          ##
          # Convenience method to apply the `private` predefined ACL
          # rule to the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.private!
          #
          def private!
            update_predefined_acl! "private"
          end

          ##
          # Convenience method to apply the `projectPrivate` predefined ACL
          # rule to the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.project_private!
          #
          def project_private!
            update_predefined_acl! "projectPrivate"
          end
          alias_method :projectPrivate!, :project_private!

          ##
          # Convenience method to apply the `publicRead` predefined ACL
          # rule to the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.public!
          #
          def public!
            update_predefined_acl! "publicRead"
          end
          alias_method :publicRead!, :public!
          alias_method :public_read!, :public!

          # Convenience method to apply the `publicReadWrite` predefined ACL
          # rule to the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.public_write!
          #
          def public_write!
            update_predefined_acl! "publicReadWrite"
          end
          alias_method :publicReadWrite!, :public_write!

          protected

          def clear!
            @owners  = nil
            @writers = nil
            @readers = nil
            self
          end

          def update_predefined_acl! acl_role
            @service.patch_bucket @bucket, predefined_acl: acl_role
            clear!
          end

          def entities_from_acls acls, role
            selected = acls.select { |acl| acl.role == role }
            entities = selected.map(&:entity)
            entities
          end
        end

        ##
        # # Bucket Default Access Control List
        #
        # Represents a Bucket's Default Access Control List.
        #
        # @example
        #   require "google/cloud/storage"
        #
        #   storage = Google::Cloud::Storage.new
        #
        #   bucket = storage.bucket "my-bucket"
        #
        #   bucket.default_acl.readers.each { |reader| puts reader }
        #
        class DefaultAcl
          # @private
          RULES = { "authenticatedRead" => "authenticatedRead",
                    "auth" => "authenticatedRead",
                    "auth_read" => "authenticatedRead",
                    "authenticated" => "authenticatedRead",
                    "authenticated_read" => "authenticatedRead",
                    "bucketOwnerFullControl" => "bucketOwnerFullControl",
                    "owner_full" => "bucketOwnerFullControl",
                    "bucketOwnerRead" => "bucketOwnerRead",
                    "owner_read" => "bucketOwnerRead",
                    "private" => "private",
                    "projectPrivate" => "projectPrivate",
                    "project_private" => "projectPrivate",
                    "publicRead" => "publicRead",
                    "public" => "publicRead",
                    "public_read" => "publicRead" }

          ##
          # @private Initialized a new DefaultAcl object.
          # Must provide a valid Bucket object.
          def initialize bucket
            @bucket = bucket.name
            @service = bucket.service
            @owners  = nil
            @readers = nil
          end

          ##
          # Reloads all Default Access Control List data for the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.default_acl.reload!
          #
          def reload!
            gapi = @service.list_default_acls @bucket
            acls = Array(gapi.items).map do |acl|
              next acl if acl.is_a? Google::Apis::StorageV1::ObjectAccessControl
              fail "Unknown ACL format: #{acl.class}" unless acl.is_a? Hash
              Google::Apis::StorageV1::ObjectAccessControl.from_json acl.to_json
            end
            @owners  = entities_from_acls acls, "OWNER"
            @readers = entities_from_acls acls, "READER"
          end
          alias_method :refresh!, :reload!

          ##
          # Lists the default owners for files in the bucket.
          #
          # @return [Array<String>]
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.default_acl.owners.each { |owner| puts owner }
          #
          def owners
            reload! if @owners.nil?
            @owners
          end

          ##
          # Lists the default readers for files in the bucket.
          #
          # @return [Array<String>]
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.default_acl.readers.each { |reader| puts reader }
          #
          def readers
            reload! if @readers.nil?
            @readers
          end

          ##
          # Grants default owner permission to files in the bucket.
          #
          # @param [String] entity The entity holding the permission, in one of
          #   the following forms:
          #
          #   * user-userId
          #   * user-email
          #   * group-groupId
          #   * group-email
          #   * domain-domain
          #   * project-team-projectId
          #   * allUsers
          #   * allAuthenticatedUsers
          #
          # @example Grant access to a user by prepending `"user-"` to an email:
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   email = "heidi@example.net"
          #   bucket.default_acl.add_owner "user-#{email}"
          #
          # @example Grant access to a group by prepending `"group-"` to email:
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   email = "authors@example.net"
          #   bucket.default_acl.add_owner "group-#{email}"
          #
          def add_owner entity
            gapi = @service.insert_default_acl @bucket, entity, "OWNER"
            entity = gapi.entity
            @owners.push entity unless @owners.nil?
            entity
          end

          ##
          # Grants default reader permission to files in the bucket.
          #
          # @param [String] entity The entity holding the permission, in one of
          #   the following forms:
          #
          #   * user-userId
          #   * user-email
          #   * group-groupId
          #   * group-email
          #   * domain-domain
          #   * project-team-projectId
          #   * allUsers
          #   * allAuthenticatedUsers
          #
          # @example Grant access to a user by prepending `"user-"` to an email:
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   email = "heidi@example.net"
          #   bucket.default_acl.add_reader "user-#{email}"
          #
          # @example Grant access to a group by prepending `"group-"` to email:
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   email = "authors@example.net"
          #   bucket.default_acl.add_reader "group-#{email}"
          #
          def add_reader entity
            gapi = @service.insert_default_acl @bucket, entity, "READER"
            entity = gapi.entity
            @readers.push entity unless @readers.nil?
            entity
          end

          ##
          # Permanently deletes the entity from the bucket's default access
          # control list for files.
          #
          # @param [String] entity The entity holding the permission, in one of
          #   the following forms:
          #
          #   * user-userId
          #   * user-email
          #   * group-groupId
          #   * group-email
          #   * domain-domain
          #   * project-team-projectId
          #   * allUsers
          #   * allAuthenticatedUsers
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   email = "heidi@example.net"
          #   bucket.default_acl.delete "user-#{email}"
          #
          def delete entity
            @service.delete_default_acl @bucket, entity
            @owners.delete entity  unless @owners.nil?
            @readers.delete entity unless @readers.nil?
            true
          end

          # @private
          def self.predefined_rule_for rule_name
            RULES[rule_name.to_s]
          end

          # Predefined ACL helpers

          ##
          # Convenience method to apply the default `authenticatedRead`
          # predefined ACL rule to files in the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.auth!
          #
          def auth!
            update_predefined_default_acl! "authenticatedRead"
          end
          alias_method :authenticatedRead!, :auth!
          alias_method :auth_read!, :auth!
          alias_method :authenticated!, :auth!
          alias_method :authenticated_read!, :auth!

          ##
          # Convenience method to apply the default `bucketOwnerFullControl`
          # predefined ACL rule to files in the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.owner_full!
          #
          def owner_full!
            update_predefined_default_acl! "bucketOwnerFullControl"
          end
          alias_method :bucketOwnerFullControl!, :owner_full!

          ##
          # Convenience method to apply the default `bucketOwnerRead`
          # predefined ACL rule to files in the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.owner_read!
          #
          def owner_read!
            update_predefined_default_acl! "bucketOwnerRead"
          end
          alias_method :bucketOwnerRead!, :owner_read!

          ##
          # Convenience method to apply the default `private`
          # predefined ACL rule to files in the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.private!
          #
          def private!
            update_predefined_default_acl! "private"
          end

          ##
          # Convenience method to apply the default `projectPrivate`
          # predefined ACL rule to files in the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.project_private!
          #
          def project_private!
            update_predefined_default_acl! "projectPrivate"
          end
          alias_method :projectPrivate!, :project_private!

          ##
          # Convenience method to apply the default `publicRead`
          # predefined ACL rule to files in the bucket.
          #
          # @example
          #   require "google/cloud/storage"
          #
          #   storage = Google::Cloud::Storage.new
          #
          #   bucket = storage.bucket "my-bucket"
          #
          #   bucket.acl.public!
          #
          def public!
            update_predefined_default_acl! "publicRead"
          end
          alias_method :publicRead!, :public!
          alias_method :public_read!, :public!

          protected

          def clear!
            @owners  = nil
            @readers = nil
            self
          end

          def update_predefined_default_acl! acl_role
            @service.patch_bucket @bucket, predefined_default_acl: acl_role
            clear!
          end

          def entities_from_acls acls, role
            selected = acls.select { |acl| acl.role == role }
            entities = selected.map(&:entity)
            entities
          end
        end
      end
    end
  end
end
