# frozen_string_literal: true

#
# Copyright (C) 2011 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

# @API Conferences
#
# API for accessing information on conferences.
#
# @model ConferenceRecording
#     {
#       "id": "ConferenceRecording",
#       "description": "",
#       "properties": {
#         "duration_minutes": {
#           "example": 0,
#           "type": "integer"
#         },
#         "title": {
#           "example": "course2: Test conference 3 [170]_0",
#           "type": "string"
#         },
#         "updated_at": {
#           "example": "2013-12-12T16:09:33.903-07:00",
#           "type": "datetime"
#         },
#         "created_at": {
#           "example": "2013-12-12T16:09:09.960-07:00",
#           "type": "datetime"
#         },
#         "playback_url": {
#           "example": "http://example.com/recording_url",
#           "type": "string"
#         }
#       }
#     }
#
# @model Conference
#     {
#       "id": "Conference",
#       "description": "",
#       "properties": {
#         "id": {
#           "description": "The id of the conference",
#           "example": 170,
#           "type": "integer"
#         },
#         "conference_type": {
#           "description": "The type of conference",
#           "example": "AdobeConnect",
#           "type": "string"
#         },
#         "conference_key": {
#           "description": "The 3rd party's ID for the conference",
#           "example": "abcdjoelisgreatxyz",
#           "type": "string"
#         },
#         "description": {
#           "description": "The description for the conference",
#           "example": "Conference Description",
#           "type": "string"
#         },
#         "duration": {
#           "description": "The expected duration the conference is supposed to last",
#           "example": 60,
#           "type": "integer"
#         },
#         "ended_at": {
#           "description": "The date that the conference ended at, null if it hasn't ended",
#           "example": "2013-12-13T17:23:26Z",
#           "type": "datetime"
#         },
#         "started_at": {
#           "description": "The date the conference started at, null if it hasn't started",
#           "example": "2013-12-12T23:02:17Z",
#           "type": "datetime"
#         },
#         "title": {
#           "description": "The title of the conference",
#           "example": "Test conference",
#           "type": "string"
#         },
#         "users": {
#           "description": "Array of user ids that are participants in the conference",
#           "example": [1, 7, 8, 9, 10],
#           "type": "array",
#           "items": { "type": "integer"}
#         },
#         "invitees": {
#           "description": "Array of user ids that are invitees in the conference",
#           "example": [1, 7, 8, 9, 10],
#           "type": "array",
#           "items": { "type": "integer"}
#         },
#         "attendees": {
#           "description": "Array of user ids that are attendees in the conference",
#           "example": [1, 7, 8, 9, 10],
#           "type": "array",
#           "items": { "type": "integer"}
#         },
#         "has_advanced_settings": {
#           "description": "True if the conference type has advanced settings.",
#           "example": false,
#           "type": "boolean"
#         },
#         "long_running": {
#           "description": "If true the conference is long running and has no expected end time",
#           "example": false,
#           "type": "boolean"
#         },
#         "user_settings": {
#           "description": "A collection of settings specific to the conference type",
#           "example": {"record": true},
#           "type": "object"
#         },
#         "recordings": {
#           "description": "A List of recordings for the conference",
#           "type": "array",
#           "items": { "$ref": "ConferenceRecording" }
#         },
#         "url": {
#           "description": "URL for the conference, may be null if the conference type doesn't set it",
#           "type": "string"
#         },
#         "join_url": {
#           "description": "URL to join the conference, may be null if the conference type doesn't set it",
#           "type": "string"
#         },
#         "context_type": {
#           "description": "The type of this conference's context, typically 'Course' or 'Group'.",
#           "type": "string"
#         },
#         "context_id": {
#           "description": "The ID of this conference's context.",
#           "type": "integer"
#         }
#       }
#     }
#
class ConferencesController < ApplicationController
  include Api::V1::Conferences
  include CalendarConferencesHelper

  before_action :require_context, except: :for_user
  skip_before_action :load_user, only: [:recording_ready]

  add_crumb(proc { t "#crumbs.conferences", "Conferences" }) do |c|
    if c.context.present?
      c.send(:named_context_url, c.context, :context_conferences_url)
    end
  end

  before_action { |c| c.active_tab = "conferences" }
  before_action :require_config, except: [:for_user]
  before_action :reject_student_view_student
  before_action :get_conference, except: %i[index create for_user]

  # @API List conferences
  # Retrieve the paginated list of conferences for this context
  #
  # This API returns a JSON object containing the list of conferences,
  # the key for the list of conferences is "conferences"
  #
  # @example_request
  #     curl 'https://<canvas>/api/v1/courses/<course_id>/conferences' \
  #         -H "Authorization: Bearer <token>"
  #
  #     curl 'https://<canvas>/api/v1/groups/<group_id>/conferences' \
  #         -H "Authorization: Bearer <token>"
  #
  # @returns [Conference]
  def index
    return unless authorized_action(@context, @current_user, :read)
    return unless tab_enabled?(@context.class::TAB_CONFERENCES)
    return unless @current_user

    page_has_instui_topnav
    log_api_asset_access(["conferences", @context], "conferences", "other")
    conferences = if @context.grants_any_right?(@current_user, *RoleOverride::GRANULAR_MANAGE_COURSE_CONTENT_PERMISSIONS)
                    @context.web_conferences.active
                  else
                    @current_user.web_conferences.active.shard(@context.shard).where(context_type: @context.class.to_s, context_id: @context.id)
                  end
    conferences = conferences.with_config_for(context: @context).order("created_at DESC, id DESC")
    api_request? ? api_index(conferences, polymorphic_url([:api_v1, @context, :conferences])) : web_index(conferences)
  end

  module UserConferencesBookmarker
    def self.bookmark_for(conference)
      # We're sorting in descending order, so we need to "flip" our sort values
      # to make sure a conference is ordered properly vis-a-vis its neighbors
      [Time.zone.now - conference.created_at, -conference.id]
    end

    def self.validate(bookmark)
      return false unless bookmark.is_a?(Array) && bookmark.length == 2

      bookmark.first.is_a?(ActiveSupport::TimeWithZone) && bookmark.second.is_a?(Integer)
    end

    def self.restrict_scope(scope, pager)
      if pager.current_bookmark
        creation_date, id = pager.current_bookmark
        comparison = pager.include_bookmark ? "<=" : "<"

        scope = scope.where("ROW(created_at, id) #{comparison} ROW(?, ?)", creation_date, id)
      end
      scope.order("created_at DESC, id DESC")
    end
  end

  # @API List conferences for the current user
  # Retrieve the paginated list of conferences for all courses and groups
  # the current user belongs to
  #
  # This API returns a JSON object containing the list of conferences.
  # The key for the list of conferences is "conferences".
  #
  # @argument state [String]
  #   If set to "live", returns only conferences that are live (i.e., have
  #   started and not finished yet). If omitted, returns all conferences for
  #   this user's groups and courses.
  #
  # @example_request
  #     curl 'https://<canvas>/api/v1/conferences' \
  #         -H "Authorization: Bearer <token>"
  #
  # @returns [Conference]
  def for_user
    return render_unauthorized_action unless @current_user
    return render json: api_conferences_json([], @current_user, session) unless WebConference.config

    log_api_asset_access(["conferences"], "conferences", "other")

    courses_collection = ShardedBookmarkedCollection.build(UserConferencesBookmarker, @current_user.enrollments) do |enrollments_scope|
      conference_scope = WebConference.active.where(context_type: "Course", context_id: enrollments_scope.active.select(:course_id))
                                      .where(WebConferenceParticipant.where("web_conference_id = web_conferences.id AND user_id = ?", @current_user.id).arel.exists)
      conference_scope = conference_scope.live if params[:state] == "live"
      conference_scope.order("created_at DESC, id DESC")
    end

    groups_collection = ShardedBookmarkedCollection.build(UserConferencesBookmarker, @current_user.groups) do |groups_scope|
      conference_scope = WebConference.active.where(context_type: "Group", context_id: groups_scope.active.select(:id))
                                      .where(WebConferenceParticipant.where("web_conference_id = web_conferences.id AND user_id = ?", @current_user.id).arel.exists)
      conference_scope = conference_scope.live if params[:state] == "live"
      conference_scope.order("created_at DESC, id DESC")
    end

    # ShardedBookmarkedCollection.build will return an ActiveRecord relation as
    # a shortcut if it finds results on fewer than two shards. We still need to
    # merge these two result sets, so re-wrap results in a bookmarked
    # collection if needed.
    courses_collection = BookmarkedCollection.wrap(UserConferencesBookmarker, courses_collection) if courses_collection.is_a?(ActiveRecord::Relation)
    groups_collection = BookmarkedCollection.wrap(UserConferencesBookmarker, groups_collection) if groups_collection.is_a?(ActiveRecord::Relation)

    merged_collection = BookmarkedCollection.merge(
      ["courses", courses_collection],
      ["groups", groups_collection]
    )

    results_page = Api.paginate(merged_collection, self, api_v1_conferences_url)
    render json: api_conferences_json(results_page, @current_user, session)
  end

  def api_index(conferences, route)
    web_conferences = Api.paginate(conferences, self, route)
    preload_recordings(web_conferences)
    render json: api_conferences_json(web_conferences, @current_user, session)
  end
  protected :api_index

  def web_index(conferences)
    conferences = conferences.to_a
    preload_recordings(conferences)
    @new_conferences, @concluded_conferences = conferences.partition do |conference|
      conference.ended_at.nil?
    end
    log_asset_access(["conferences", @context], "conferences", "other")

    GuardRail.activate(:secondary) do
      @render_alternatives = WebConference.conference_types(@context).all? { |ct| ct[:replace_with_alternatives] }
      case @context
      when Course
        @sections = @context.course_sections.active
        @groups = @context.active_groups

        @group_user_ids_map = @groups.to_a.each_with_object({}) do |group, acc|
          acc[group.id] = group.participating_users_in_context.map { |u| u.id.to_s }
          acc
        end

        @section_user_ids_map = @sections.to_a.each_with_object({}) do |section, acc|
          acc[section.id] = section.participants.map { |u| u.id.to_s }
          acc
        end
        @users = User.where(id: @context.current_enrollments.not_fake.active_by_date.where.not(user_id: @current_user).select(:user_id))
                     .order(User.sortable_name_order_by_clause).to_a
        @render_alternatives ||= @context.settings[:show_conference_alternatives].present?
      when Group
        @users = @context.participating_users_in_context.where("users.id<>?", @current_user).order(User.sortable_name_order_by_clause).to_a.uniq
        @render_alternatives ||= @context.context.settings[:show_conference_alternatives].present?
      else
        @users = @context.users.where("users.id<>?", @current_user).order(User.sortable_name_order_by_clause).to_a.uniq
      end
    end

    bbb_config = WebConference.config(class_name: BigBlueButtonConference.to_s)

    # exposing the initial data as json embedded on page.
    js_env(
      current_conferences: ui_conferences_json(@new_conferences, @context, @current_user, session),
      concluded_conferences: ui_conferences_json(@concluded_conferences, @context, @current_user, session),
      default_conference: default_conference_json(@context, @current_user, session),
      conference_type_details: conference_types_json(WebConference.conference_types(@context)),
      users: @users.map { |u| { id: u.id, name: u.last_name_first } },
      groups: @groups&.map { |g| { id: g.id, name: g.full_name } },
      sections: @sections&.map { |s| { id: s.id, name: s.display_name } },
      group_user_ids_map: @group_user_ids_map,
      section_user_ids_map: @section_user_ids_map,
      can_create_conferences: @context.grants_right?(@current_user, session, :create_conferences),
      can_manage_calendar: @context.grants_right?(@current_user, session, :manage_calendar),
      render_alternatives: @render_alternatives,
      bbb_recording_enabled: bbb_config ? bbb_config[:recording_enabled] : false,
      context_name: @context&.name || nil
    )
    set_tutorial_js_env
    flash[:error] = t("Some conferences on this page are hidden because of errors while retrieving their status") if @errors
  end
  protected :web_index

  def show
    if authorized_action(@conference, @current_user, :read)
      if params[:external_url]
        urls = @conference.external_url_for(params[:external_url], @current_user, params[:url_id])
        if request.xhr?
          return render json: urls
        elsif urls.size == 1
          return redirect_to(urls.first[:url])
        end
      end
      redirect_to course_conferences_url(@context, anchor: "conference_#{@conference.id}")
    end
  end

  def create_or_update_calendar_event_for_conference(conference, context)
    return nil unless context.is_a?(Course)

    calendar_event_data = { title: conference.title, web_conference: conference, context_code: context.asset_string, start_at: conference.start_at, end_at: conference.end_at }
    find_and_update_or_initialize_calendar_event(context, calendar_event_data)
  end

  def create
    if authorized_action(@context.web_conferences.temp_record, @current_user, :create)
      calendar_event_param = params[:web_conference].try(:delete, :calendar_event).try(&:to_i)
      @conference = @context.web_conferences.build(conference_params)
      @conference.settings[:default_return_url] = named_context_url(@context, :context_url, include_host: true)
      @conference.user = @current_user
      respond_to do |format|
        if @conference.save
          if calendar_event_param && calendar_event_param == 1
            calendar_event = create_or_update_calendar_event_for_conference(@conference, @context)
            calendar_event&.save
          end
          user_ids = member_ids
          @conference.add_initiator(@current_user)
          (user_ids.count > WebConference.max_invitees_sync_size) ? @conference.delay.invite_users_from_context(user_ids) : @conference.invite_users_from_context(user_ids)
          @conference.save
          format.html { redirect_to named_context_url(@context, :context_conference_url, @conference.id) }
          format.json do
            render json: WebConference.find(@conference.id).as_json(permissions: { user: @current_user, session: },
                                                                    url: named_context_url(@context, :context_conference_url, @conference))
          end
        else
          flash[:error] = t("errors.create_failed", "Conference creation failed")
          format.html { render :index }
          format.json { render json: @conference.errors, status: :bad_request }
        end
      end
    end
  end

  def update
    if authorized_action(@conference, @current_user, :update)
      @conference.user ||= @current_user
      respond_to do |format|
        params[:web_conference].try(:delete, :long_running)
        params[:web_conference].try(:delete, :conference_type)
        sync_attendees = params[:web_conference].try(:delete, :sync_attendees).try(&:to_i)

        @conference.invite_users_from_context if sync_attendees == 1

        calendar_event_param = params[:web_conference].try(:delete, :calendar_event).try(&:to_i)
        if @conference.update(conference_params)
          # TODO: ability to dis-invite people
          @conference.invite_users_from_context(member_ids) unless sync_attendees == 1

          unless sync_attendees == 1
            if calendar_event_param && calendar_event_param == 1
              calendar_event = create_or_update_calendar_event_for_conference(@conference, @context)
              calendar_event&.save
            elsif @conference.calendar_event
              @conference.calendar_event.destroy
              @conference.calendar_event = nil
            end
          end

          @conference.save
          format.html { redirect_to named_context_url(@context, :context_conference_url, @conference.id) }
          format.json do
            render json: @conference.as_json(permissions: { user: @current_user, session: },
                                             url: named_context_url(@context, :context_conference_url, @conference))
          end
        else
          format.html { render :edit }
          format.json { render json: @conference.errors, status: :bad_request }
        end
      end
    end
  end

  def join
    if authorized_action(@conference, @current_user, :join)
      unless @conference.valid_config?
        flash[:error] = t(:type_disabled_error, "This type of conference is no longer enabled for this Canvas site")
        redirect_to named_context_url(@context, :context_conferences_url)
        return
      end
      if @conference.grants_right?(@current_user, session, :initiate) || @conference.grants_right?(@current_user, session, :resume) || @conference.active?(true)
        @conference.add_attendee(@current_user)
        @conference.restart if @conference.ended_at && @conference.grants_right?(@current_user, session, :initiate)
        log_asset_access(@conference, "conferences", "conferences", "participate")
        if (url = @conference.craft_url(@current_user, session, named_context_url(@context, :context_url, include_host: true)))
          redirect_to url
        else
          flash[:error] = t(:general_error, "There was an error joining the conference")
          redirect_to named_context_url(@context, :context_url)
        end
      else
        flash[:notice] = t(:inactive_error, "That conference is not currently active")
        redirect_to named_context_url(@context, :context_url)
      end
    end
  rescue => e
    Canvas::Errors.capture(e)
    flash[:error] = t("There was an error joining the conference.")
    redirect_to named_context_url(@context, :context_conferences_url)
  end

  def recording_ready
    secret = @conference.config[:secret_dec]
    begin
      signed_params = Canvas::Security.decode_jwt(params[:signed_parameters], [secret])
      if signed_params[:meeting_id] == @conference.conference_key
        @conference.recording_ready!
        render json: [], status: :accepted
      else
        render json: signed_id_invalid_json, status: :unprocessable_entity
      end
    rescue Canvas::Security::InvalidToken
      render json: invalid_jwt_token_json, status: :unauthorized
    end
  end

  def close
    if authorized_action(@conference, @current_user, :close)
      unless @conference.active?
        return render json: { message: "conference is not active", status: :bad_request }
      end

      if @conference.close
        render json: @conference.as_json(permissions: { user: @current_user, session: },
                                         url: named_context_url(@context, :context_conference_url, @conference))
      else
        render json: @conference.errors
      end
    end
  end

  def settings
    if authorized_action(@conference, @current_user, :update)
      if @conference.has_advanced_settings?
        redirect_to @conference.admin_settings_url(@current_user)
      else
        flash[:error] = t(:no_settings_error, "The conference does not have an advanced settings page")
        redirect_to named_context_url(@context, :context_conference_url, @conference.id)
      end
    end
  end

  def destroy
    if authorized_action(@conference, @current_user, :delete)
      @conference.transaction do
        @conference.web_conference_participants.scope.delete_all
        CalendarEvent.where(web_conference_id: @conference.id).each do |calendar_event|
          calendar_event.update_columns(web_conference_id: nil)
        end
        @conference.destroy
      end
      respond_to do |format|
        format.html { redirect_to named_context_url(@context, :context_conferences_url) }
        format.json { render json: @conference }
      end
    end
  end

  def recording
    if authorized_action(@conference, @current_user, :read)
      @response = @conference.recording(params[:recording_id]) || {}
      respond_to do |format|
        format.html { redirect_to named_context_url(@context, :context_conferences_url) }
        format.json { render json: @response }
      end
    end
  end

  def delete_recording
    if authorized_action(@conference, @current_user, :delete)
      @response = @conference.delete_recording(params[:recording_id])
      respond_to do |format|
        format.html { redirect_to named_context_url(@context, :context_conferences_url) }
        format.json { render json: @response, status: :ok }
      end
    end
  end

  protected

  def require_config
    unless WebConference.config(context: @context)
      flash[:error] = t("#conferences.disabled_error", "Web conferencing has not been enabled for this Canvas site")
      redirect_to named_context_url(@context, :context_url)
    end
  end

  def member_ids
    ids = [@current_user.id]
    if params[:observers] && params[:observers][:remove] == "1"
      ids += @context.user_ids - @context.observers.pluck(:id)
    elsif params[:user] && params[:user][:all] != "1"
      ids = []
      params[:user].each do |id, val|
        ids << id.to_i if val == "1"
      end
    else
      ids = @context.user_ids
    end

    ids
  end

  private

  def get_conference
    @conference = @context.web_conferences.find(params[:conference_id] || params[:id])
  end

  def conference_params
    params.require(:web_conference)
          .permit(:start_at, :end_at, :sync_attendees, :title, :duration, :description, :conference_type, user_settings: strong_anything, lti_settings: strong_anything)
  end

  def preload_recordings(conferences)
    conferences.group_by(&:class).each do |klass, klass_conferences|
      if klass.respond_to?(:preload_recordings) # should only be BigBlueButton for now
        klass.preload_recordings(klass_conferences)
      end
    end
  end
end
